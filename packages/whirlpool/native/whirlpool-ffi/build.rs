use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;


fn main() {
    println!("cargo:rerun-if-changed=../whirlpool-java/src/main/WhirlpoolEnvoy.java");

    let current_dir = env::current_dir().unwrap();
    let java_dir = current_dir.parent().unwrap().join("whirlpool-java");

    // Compile WhirlpoolEnvoy to bytecode
    Command::new("mvn").args(&["gluonfx:sharedlib"])
        .current_dir(java_dir.clone())
        .status().unwrap();

    // Compile bytecode to native library
    // Command::new("native-image").args(&["--shared", "-jar", "target/whirlpool-envoy-0.0.1.jar", "libwhirlpool-envoy"])
    //     .current_dir(java_dir)
    //     .status().unwrap();

    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();

    let include_path = match target_os.as_str() {
        "linux" => { "../whirlpool-java/target/gluonfx/x86_64-linux/gvm/whirlpool-envoy" }
        _ => { panic!("Unknown target OS") }
    };

    // Generate bindings.rs from native-image header files
    let bindings = bindgen::Builder::default()
        .header(include_path.to_owned() + "/whirlpoolenvoy.h")
        .clang_arg("-I".to_owned() + include_path)
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    bindings
        .write_to_file(current_dir.join("src").join("bindings.rs"))
        .expect("Couldn't write bindings!");

    println!("cargo:rustc-link-search={}/{}", current_dir.display(), include_path);
}
