use std::fs::{self};
use std::path::Path;
use std::process::Command;

#[test]
fn process_sy_files() {
    let testcase_dir = "testcase";
    let entries = fs::read_dir(testcase_dir).expect("Failed to read testcase directory");

    for entry in entries {
        let entry = entry.expect("Failed to access entry in testcase directory");
        let path = entry.path();

        // Ensure the file has a .sy extension
        if let Some(extension) = path.extension()
            && extension == "sy"
        {
            let input_file = path.to_str().unwrap();

            // Prepare corresponding .out file path
            let mut output_path = path.clone();
            output_path.set_extension("out");

            let output_file = output_path.to_str().unwrap();

            // Run the lexer binary with the input file
            let output = Command::new("cargo")
                .args([
                    "run",
                    "--release",
                    "--",
                    "-i",
                    input_file,
                    "-o",
                    output_file,
                ])
                .output()
                .expect("Failed to execute lexer");

            if !output.status.success() {
                panic!("Test failed: {}", String::from_utf8_lossy(&output.stderr));
            }

            // Verify .out file exists
            assert!(Path::new(output_file).exists(), "Output file not created");
        }
    }
}
