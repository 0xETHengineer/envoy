use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;


fn main() {
    println!("cargo:rerun-if-changed=../whirlpool-java/src/main/WhirlpoolEnvoy.java");

    let current_dir = env::current_dir().unwrap();
    let java_dir = current_dir.parent().unwrap().join("whirlpool-java");

    // Compile WhirlpoolEnvoy to bytecode
    Command::new("mvn").args(&["clean", "install"])
        .current_dir(java_dir.clone())
        .status().unwrap();

    // Compile bytecode to native library
    // Command::new("native-image").args(&["--shared", "-jar", "target/whirlpool-envoy-0.0.1.jar", "libwhirlpool-envoy"])
    //     .current_dir(java_dir)
    //     .status().unwrap();

    // Generate bindings.rs from native-image header files
    let bindings = bindgen::Builder::default()
        .header("../whirlpool-java/libwhirlpool-envoy.h")
        .clang_arg("-I../whirlpool-java")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    bindings
        .write_to_file(current_dir.join("src").join("bindings.rs"))
        .expect("Couldn't write bindings!");

    println!("cargo:rustc-link-search={}/../whirlpool-java", current_dir.display());
}
