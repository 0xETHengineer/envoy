// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

use std::ffi::{CStr, CString};
use std::os::raw::c_char;

pub struct WhirlpoolClient {

}

#[no_mangle]
pub unsafe extern "C" fn whirlpool(
) -> *mut WhirlpoolClient {
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
