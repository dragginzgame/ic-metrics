//! Inspect explicit raw Wasm inputs without executing or transforming them.

use std::{env, io, io::Write, process::ExitCode};

mod args;
mod report;

fn main() -> ExitCode {
    let result = args::parse(env::args_os().skip(1)).and_then(|command| match command {
        args::Command::Help => {
            writeln!(io::stdout().lock(), "{}", args::USAGE).map_err(report::Error::Output)
        }
        args::Command::Inspect { path, limits } => {
            let bytes = ic_host_fs::read::read_file(&path, limits.module_bytes)
                .map_err(report::Error::Input)?;
            report::write(&bytes, limits, &mut io::stdout().lock())
        }
    });
    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            let _ = writeln!(io::stderr().lock(), "{error}");
            ExitCode::FAILURE
        }
    }
}
