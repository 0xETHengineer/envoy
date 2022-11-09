use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;


fn main() {
    println!("cargo:rerun-if-changed=../whirlpool-java/src/main/WhirlpoolEnvoy.java");

    let current_dir = env::current_dir().unwrap();
    let java_dir = current_dir.parent().unwrap().join("whirlpool-java");

    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();

    let native_image_target = match target_os.as_str() {
        "linux" => { "x86_64-linux" }
        "ios" => { "arm64-ios" }
        "android" => { "aarch64-android" }
        _ => { panic!("Unknown target OS") }
    };

    let lib_path = format!("../whirlpool-java/target/gluonfx/{}", native_image_target);
    let include_path = format!("{}/gvm/whirlpool-envoy", lib_path);

    let mut maven_args = vec!["gluonfx:sharedlib"];

    match target_os.as_str() {
        "android" => { maven_args.push("-Pandroid"); }
        "ios" => { maven_args.push("-Pios"); }
        _ => { }
    };

    // Compile WhirlpoolEnvoy to bytecode
    Command::new("mvn").args(maven_args)
        .current_dir(java_dir.clone())
        .status().unwrap();

    // Generate bindings.rs from native-image header files
    let bindings = bindgen::Builder::default()
        .header(include_path.to_owned() + "/whirlpoolenvoy.h")
        .clang_arg("-I".to_owned() + include_path.as_str())
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    bindings
        .write_to_file(current_dir.join("src").join("bindings.rs"))
        .expect("Couldn't write bindings!");

    println!("cargo:rustc-link-search={}/{}", current_dir.display(), lib_path);
}
