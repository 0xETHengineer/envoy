use std::env;
use std::path::Path;
use std::process::Command;


fn main() {
    let current_dir = env::current_dir().unwrap();

    let java_dir_str = format!("{}/../whirlpool-java", current_dir.to_str().unwrap());
    let java_dir = Path::new(&java_dir_str);

    // Compile WhirlpoolEnvoy to bytecode
    Command::new("mvn").args(&["clean", "install"])
        .current_dir(java_dir)
        .status().unwrap();

    // Compile bytecode to native library
    Command::new("native-image").args(&["--shared", "-jar", "target/whirlpool-envoy-0.0.1.jar", "libwhirlpool-envoy"])
        .current_dir(java_dir)
        .status().unwrap();

    // native-image --shared -jar target/whirlpool-client-0.23.46.jar WhirlpoolEnvoy
    println!("cargo:rustc-link-search={}/../whirlpool-java", current_dir.display());
}
