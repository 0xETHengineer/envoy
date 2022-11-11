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
    graal_thread: *mut graal_isolatethread_t,
}

#[no_mangle]
pub unsafe extern "C" fn whirlpool_start(
) -> *mut WhirlpoolClient {

    print!("Rust: whirlpool!");

    let mut thread: *mut graal_isolatethread_t = null_mut();

    if graal_create_isolate(null_mut(), null_mut(), &mut thread) != 0 {
        panic!("graal_create_isolate error");
    }

    if bindings::whirlpool(thread) != 1 {
        let error = CStr::from_ptr(bindings::get_last_error(thread));
        panic!("{}", error.to_str().unwrap());
    }

    let whirlpool_box = Box::new(WhirlpoolClient{
        graal_thread: thread
    });
    Box::into_raw(whirlpool_box)
}

#[no_mangle]
pub unsafe extern "C" fn whirlpool_stop(whirlpool: *mut WhirlpoolClient) {
    let whirlpool = {
        assert!(!whirlpool.is_null());
        &mut *whirlpool
    };

    bindings::stop(whirlpool.graal_thread);
}
