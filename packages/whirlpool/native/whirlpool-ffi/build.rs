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
        _ => { panic!("Unknown target OS") }
    };

    let include_path = format!("../whirlpool-java/target/gluonfx/{}/gvm/whirlpool-envoy", native_image_target);

    let gluonfx_target = match target_os.as_str() {
        "android" => { "-Pandroid" }
        "ios" => { "-Pios" }
        _ => { "" }
    };

    // Compile WhirlpoolEnvoy to bytecode
    Command::new("mvn").args(&["clean", "gluonfx:sharedlib", gluonfx_target])
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

    println!("cargo:rustc-link-search={}/{}", current_dir.display(), include_path);
}
