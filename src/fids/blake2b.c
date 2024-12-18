/*
 * Copyright (C) 2014-2024 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

/* A simple unkeyed BLAKE2b Implementation based on the official reference
 * from https://github.com/BLAKE2/BLAKE2.
 *
 * The original code was released under CC0 1.0 Universal license (Creative Commons),
 * a public domain license.
 */

#include "fids.h"

// little-endian vs big-endian is irrelevant since the checksum is calculated and checked on the same computer.
static inline uint64_t load64( const void *src ) {
	uint64_t w;
	memcpy( &w, src, sizeof( w ) );
	return w;
}

// mixing function
#define ROTR64(x, y)  (((x) >> (y)) ^ ((x) << (64 - (y))))
#define G(a, b, c, d, x, y) {   \
		v[a] = v[a] + v[b] + x;         \
		v[d] = ROTR64(v[d] ^ v[a], 32); \
		v[c] = v[c] + v[d];             \
		v[b] = ROTR64(v[b] ^ v[c], 24); \
		v[a] = v[a] + v[b] + y;         \
		v[d] = ROTR64(v[d] ^ v[a], 16); \
		v[c] = v[c] + v[d];             \
		v[b] = ROTR64(v[b] ^ v[c], 63); }

// init vector
static const uint64_t iv[8] = {
	0x6A09E667F3BCC908, 0xBB67AE8584CAA73B,
	0x3C6EF372FE94F82B, 0xA54FF53A5F1D36F1,
	0x510E527FADE682D1, 0x9B05688C2B3E6C1F,
	0x1F83D9ABFB41BD6B, 0x5BE0CD19137E2179
};


const uint8_t sigma[12][16] = {
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
	{ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
	{ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
	{ 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 },
	{ 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 },
	{ 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 },
	{ 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 },
	{ 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 },
	{ 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 },
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 }
};

// blake2b context
typedef struct {
	uint8_t b[128];                     // input buffer
	uint64_t h[8];                      // chained state
	uint64_t t[2];                      // total number of bytes
	size_t c;                           // pointer for b[]
	size_t outlen;                      // digest size
} CTX;

// compress function
static void compress(CTX *ctx, int last) {
	uint64_t m[16];
	uint64_t v[16];
	size_t i;

	for (i = 0; i < 16; i++)
		m[i] = load64(&ctx->b[8 * i]);

	for (i = 0; i < 8; i++) {
		v[i] = ctx->h[i];
		v[i + 8] = iv[i];
	}

	v[12] ^= ctx->t[0];
	v[13] ^= ctx->t[1];
	if (last)
		v[14] = ~v[14];

	for (i = 0; i < 12; i++) {
		G( 0, 4,  8, 12, m[sigma[i][ 0]], m[sigma[i][ 1]]);
		G( 1, 5,  9, 13, m[sigma[i][ 2]], m[sigma[i][ 3]]);
		G( 2, 6, 10, 14, m[sigma[i][ 4]], m[sigma[i][ 5]]);
		G( 3, 7, 11, 15, m[sigma[i][ 6]], m[sigma[i][ 7]]);
		G( 0, 5, 10, 15, m[sigma[i][ 8]], m[sigma[i][ 9]]);
		G( 1, 6, 11, 12, m[sigma[i][10]], m[sigma[i][11]]);
		G( 2, 7,  8, 13, m[sigma[i][12]], m[sigma[i][13]]);
		G( 3, 4,  9, 14, m[sigma[i][14]], m[sigma[i][15]]);
	}

	for( i = 0; i < 8; ++i )
		ctx->h[i] ^= v[i] ^ v[i + 8];
}

static int init(CTX *ctx, size_t outlen) {      // (keylen=0: no key)
	size_t i;

	if (outlen == 0 || outlen > 64)
		return -1;

	for (i = 0; i < 8; i++)
		ctx->h[i] = iv[i];
	ctx->h[0] ^= 0x01010000  ^ outlen;

	ctx->t[0] = 0;
	ctx->t[1] = 0;
	ctx->c = 0;
	ctx->outlen = outlen;

	return 0;
}

static void update(CTX *ctx, const void *in, size_t inlen) {
	size_t i;

	for (i = 0; i < inlen; i++) {
		if (ctx->c == 128) {
			ctx->t[0] += ctx->c;
			if (ctx->t[0] < ctx->c)
				ctx->t[1]++;
			compress(ctx, 0);
			ctx->c = 0;
		}
		ctx->b[ctx->c++] = ((const uint8_t *) in)[i];
	}
}

static void final(CTX *ctx, void *out) {
	size_t i;

	ctx->t[0] += ctx->c;
	if (ctx->t[0] < ctx->c)
		ctx->t[1]++;

	while (ctx->c < 128)
		ctx->b[ctx->c++] = 0;
	compress(ctx, 1);

	for (i = 0; i < ctx->outlen; i++) {
		((uint8_t *) out)[i] =
			(ctx->h[i >> 3] >> (8 * (i & 7))) & 0xFF;
	}
}

// public function
int blake2b(void *out, size_t outlen, const void *in, size_t inlen) {
	CTX ctx;

	if (init(&ctx, outlen))
		return -1;
	update(&ctx, in, inlen);
	final(&ctx, out);

	return 0;
}
