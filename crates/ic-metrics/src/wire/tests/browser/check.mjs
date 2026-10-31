import assert from 'node:assert/strict';
import { readFileSync, writeFileSync } from 'node:fs';
import { MetricsReport } from './reports.ts';
import { WireError } from './wire-runtime.ts';

const max64 = (1n << 64n) - 1n;
const max128 = (1n << 128n) - 1n;
// Independent consumer values: never decode Rust JSON numeric fields through Number.
const values = [
  ['empty', 0n, 0n, null, false],
  ['zero', 1n, 0n, 0n, false],
  ['wide', 2n, max64 * 2n, max64, false],
  ['cap', max64, max64 * max64, max64, false],
  ['lost', max64, max128, max64, true],
];
const rust = JSON.parse(readFileSync(new URL('./rust.json', import.meta.url)));
assert.equal(rust.length, values.length);
const encoded = values.map(([name, samples, total, maximum, lost], index) => {
  assert.equal(rust[index].name, name);
  const aggregate = {
    samples, total, maximum: maximum === null ? null : { some: maximum },
    samples_overflowed: lost, total_overflowed: lost,
  };
  const expected = {
    aggregate,
    counter: { total: samples > 1n ? max128 : 0n, total_overflowed: lost },
    summary: { aggregate, latest: aggregate.maximum },
    histogram: {
      upper_bounds: Array.from({ length: 37 }, (_, bound) => BigInt(bound)),
      bucket_counts: Array.from({ length: 37 }, (_, bucket) => name === 'zero' && bucket === 0 ? 1n : 0n),
      overflow: name === 'zero' ? 0n : samples,
      bucket_overflowed: Array(37).fill(false),
      overflow_count_overflowed: lost,
      aggregate,
    },
  };
  const rustBytes = Uint8Array.from(rust[index].bytes);
  assert.deepEqual(structuredClone(MetricsReport.decode(rustBytes)), expected, `${name}: Rust -> TS`);
  const tsBytes = MetricsReport.encode(expected);
  assert.deepEqual(tsBytes, rustBytes, `${name}: TS -> Rust bytes`);
  assert.throws(() => MetricsReport.decode(rustBytes.subarray(0, rustBytes.length - 1)),
    error => error instanceof WireError && error.code === 'malformed');
  const wrongLength = structuredClone(expected);
  wrongLength.histogram.bucket_counts.pop();
  assert.throws(() => MetricsReport.encode(wrongLength),
    error => error instanceof WireError && error.code === 'limit');
  return Array.from(tsBytes);
});
writeFileSync(new URL('./typescript.json', import.meta.url), JSON.stringify(encoded));
console.log(`${encoded.length} Rust/TypeScript reports passed, including malformed input rejection`);
