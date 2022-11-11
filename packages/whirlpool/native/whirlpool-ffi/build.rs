use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;
use cbindgen::{Config, Language};

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

    let java_lib_path = format!("../whirlpool-java/target/gluonfx/{}", native_image_target);
    let include_path = format!("{}/gvm/whirlpool-envoy", java_lib_path);

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
    let java_bindings = bindgen::Builder::default()
        .header(include_path.to_owned() + "/whirlpoolenvoy.h")
        .clang_arg("-I".to_owned() + include_path.as_str())
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    java_bindings
        .write_to_file(current_dir.join("src").join("bindings.rs"))
        .expect("Couldn't write bindings!");

    // Create C header files for Dart
    let crate_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    let package_name = env::var("CARGO_PKG_NAME").unwrap();

    let output_file = target_dir()
        .join(format!("{}.hpp", package_name))
        .display()
        .to_string();

    let config = Config {
        language: Language::C,
        ..Default::default()
    };

    cbindgen::generate_with_config(&crate_dir, config)
        .unwrap()
        .write_to_file(&output_file);

    println!("cargo:rustc-link-search={}/{}", current_dir.display(), java_lib_path);
}

fn target_dir() -> PathBuf {
    if let Ok(target) = env::var("CARGO_TARGET_DIR") {
        PathBuf::from(target)
    } else {
        PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap()).join("target")
    }
}