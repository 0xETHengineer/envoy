// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#[allow(non_camel_case_types)]
#[allow(unused_variables)]
#[allow(non_upper_case_globals)]
#[allow(dead_code)]
mod bindings;

use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::ptr::{null, null_mut};
use crate::bindings::{graal_create_isolate, graal_isolatethread_t};

#[link(name = "whirlpool-envoy")]
extern {
    fn start(source_length: bool) -> bool;
}

// TODO: do some isolate magic here to be able to communicate events
pub struct WhirlpoolClient {

}

#[no_mangle]
pub unsafe extern "C" fn whirlpool(
) -> *mut WhirlpoolClient {

    print!("Rust: whirlpool!");

    let thread = null_mut();

    if graal_create_isolate(null_mut(), null_mut(), thread) != 0 {
        panic!("graal_create_isolate error");
    }

    //graal_isolatethread_t *thread = NULL;
    // if (graal_create_isolate(NULL, NULL, &thread) != 0) {
    //   fprintf(stderr, "graal_create_isolate error\n");
    //   return 1;
    // }
    // ...
    // double distance = runGH(thread, lat1, lon1, lat2, lon2);
    // std::cout << "Distance calculated by GraphHopper " << distance << std::endl;

    //let ret = bindings::whirlpool();

    let whirlpool_box = Box::new(WhirlpoolClient{});
    Box::into_raw(whirlpool_box)
}

#[no_mangle]
pub unsafe extern "C" fn whirlpool_stop(whirlpool: *mut WhirlpoolClient) {
    let whirlpool = {
        assert!(!whirlpool.is_null());
        &mut *whirlpool
    };
}
