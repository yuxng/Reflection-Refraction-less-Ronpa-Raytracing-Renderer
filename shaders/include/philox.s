#pragma once

/*
Counter based  pseudorandom number generator Philox

It is introduced in this paper:
Parallel Random Numbers: As Easy as 1, 2, 3
by John K. Salmon, Mark A. Moraes, Ron O. Dror, and David E. Shaw

Philox is a modification of Threefish.
It is explained in 2.2 and 3.3 in this paper:
The Skein Hash Function Family
by Niels Ferguson, Stefan Lucks, Bruce Schneier, Doug Whiting, Mihir Bellare, Tadayoshi Kohno, Jon Callas, Jesse Walker

You can download original Random123 source code from here:
http://www.thesalmons.org/john/random123/

How to use:
uvec4 counter;
uvec2 key;
uintToFloat(Philox4x32(counter, key))
returns pseudorandom vec4 value where each components are [0, 1).
*/
uvec2 philox4x32Bumpkey(uvec2 key) {
    uvec2 ret = key;
    ret.x += 0x9E3779B9u;
    ret.y += 0xBB67AE85u;
    return ret;
}

uvec4 philox4x32Round(uvec4 state, uvec2 key) {
    const uint M0 = 0xD2511F53u, M1 = 0xCD9E8D57u;
    uint hi0, lo0, hi1, lo1;
    umulExtended(M0, state.x, hi0, lo0);
    umulExtended(M1, state.z, hi1, lo1);

    return uvec4(
        hi1^state.y^key.x, lo1,
        hi0^state.w^key.y, lo0);
}

uvec4 Philox4x32(uvec4 plain, uvec2 key) {
    uvec4 state = plain;
    uvec2 round_key = key;

    for(int i=0; i<7; ++i) {
        state = philox4x32Round(state, round_key);
        round_key = philox4x32Bumpkey(round_key);
    }

    return state;
}

float uintToFloat(uint src) {
    return uintBitsToFloat(0x3f800000u | (src & 0x7fffffu))-1.0;
}

vec4 uintToFloat(uvec4 src) {
    return vec4(uintToFloat(src.x), uintToFloat(src.y), uintToFloat(src.z), uintToFloat(src.w));
}

