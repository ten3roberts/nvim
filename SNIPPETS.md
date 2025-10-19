# Snippets Guide

This document provides an overview of available custom snippets in this Neovim configuration. Snippets are powered by [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) via Blink.cmp, with additional custom snippets defined in `snippets/`.

## Lua Snippets

| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `fn` / `function` | Basic function definition | `function name(args) end` |
| `lfn` / `local function` | Local function definition | `local function name(args) end` |
| `append` | Table insert | `table.insert(t, val)` |
| `req` / `require` | Module require | `require("module")` |
| `lreq` / `local require` | Local require with variable | `local var = require("module")` |
| `class` | EmmyLua class annotation | `---@class` |
| `field` | EmmyLua field annotation | `---@field` |
| `param` | EmmyLua param annotation | `---@param` |
| `date` | Date insertion | `os.date('%Y-%m-%d')` |

## Rust Snippets

### Logging
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `trace` | Trace log | `tracing::trace!("message");` |
| `debug` | Debug log | `tracing::debug!("message");` |
| `info` | Info log | `tracing::info!("message");` |
| `warn` | Warn log | `tracing::warn!("message");` |
| `error` | Error log | `tracing::error!("message");` |

### Spans and Instrumentation
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `info_span` | Info span | `let _span = tracing::info_span!("name").entered();` |
| `debug_span` | Debug span | `let _span = tracing::debug_span!("name").entered();` |
| `instrument` | Basic instrument | `#[tracing::instrument(level = "info")]` |
| `instrument_trace` | Trace instrument | `#[tracing::instrument(level = "trace")]` |
| `instrument_debug` | Debug instrument | `#[tracing::instrument(level = "debug")]` |
| `instrument_info` | Info instrument | `#[tracing::instrument(level = "info")]` |
| `instrument_warn` | Warn instrument | `#[tracing::instrument(level = "warn")]` |
| `instrument_error` | Error instrument | `#[tracing::instrument(level = "error")]` |

### Testing
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `test` | Test function | `#[test] fn name() { }` |
| `modtests` | Test module | `#[cfg(test)] mod tests { use super::*; }` |
| `assert-eq` | Assert equal | `assert_eq!(left, right);` |
| `assert` | Assert | `assert!(condition);` |

### Patterns and Matching
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `if-ok` | If let Ok | `if let Ok(var) = expr { }` |
| `if-some` | If let Some | `if let Some(var) = expr { }` |
| `match-result` | Match Result | `match expr { Ok(v) => , Err(e) => }` |
| `match-option` | Match Option | `match expr { Some(v) => , None => }` |

### Derives and Attributes
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `derive` | Derive macro | `#[derive(trait)]` |
| `serde-derive` | Serde derive | `#[derive(serde::Serialize, serde::Deserialize)]` |
| `serde-attr` | Serde cfg attr | `#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]` |
| `de_serde` | Serde derive | `#[derive(serde::Serialize, serde::Deserialize)]` |
| `attr_serde` | Serde cfg attr | `#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]` |
| `doc_hidden` | Doc hidden | `#[doc(hidden)]` |

### Structs and Enums
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `struct` | Struct | `#[derive(Debug, Clone)] struct Name { }` |
| `enum` | Enum | `#[derive(Debug, Clone)] enum Name { }` |
| `impl` | Impl block | `impl<T> Type { }` |
| `impl-trait` | Impl trait | `impl Trait for Type { }` |
| `pubuse` | Public use | `pub use crate::*;` |
| `struct-pod` | POD struct | `#[repr(C)] #[derive(bytemuck::Pod, bytemuck::Zeroable, Clone, Copy, Debug)] pub struct Name { }` |

### Functions
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `fn` | Function | `fn name() -> _ { todo!() }` |
| `pf` | Public function | `pub fn name() -> _ { todo!() }` |
| `fnew` | New function | `pub fn new(args) -> Self { Self { } }` |
| `async-fn` | Async function | `async fn name(args) -> Type { }` |

### Collections and Iterators
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `vec` | Vec new | `vec![item]` |
| `hashmap` | HashMap new | `std::collections::HashMap::new()` |
| `buf` | Buffer | `let mut buf = Vec::new();` |
| `map-collect` | Map collect | `expr.iter().map(|v| ).collect::<Vec<_>>()` |
| `filter-map` | Filter map | `expr.iter().filter_map(|v| ).collect::<Vec<_>>()` |
| `fold` | Fold | `expr.iter().fold(init, |acc, v| )` |
| `map_into` | Map into | `map(Into::into)` |
| `map_err` | Map err | `map_err(Into::into)` |

### Async and Concurrency
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `tokio-spawn` / `spawn` | Tokio spawn | `tokio::spawn(async move { });` |
| `join-handle` / `join` | Join handle | `expr.await.expect("msg")` |

### Conditional Compilation
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `cfg_unknown` | Cfg unknown OS | `#[cfg(target_os = "unknown")]` |
| `cfg_not_unknown` | Cfg not unknown OS | `#[cfg(not(target_os = "unknown"))]` |
| `cfg_arch` | Cfg arch | `#[cfg(target_arch = "arch")]` |
| `cfg_not_arch` | Cfg not arch | `#[cfg(not(target_arch = "arch"))]` |
| `cfg_wasm32` | Cfg WASM32 | `#[cfg(target_arch = "wasm32")]` |
| `cfg_not_wasm32` | Cfg not WASM32 | `#[cfg(not(target_arch = "wasm32"))]` |
| `cfgf` | Cfg feature | `#[cfg(feature = "feature")]` |

### Utilities
| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `cowstr` | Cow string | `Cow<'static, str>` |
| `icowstr` | Into Cow string | `Into<Cow<'static, str>>` |
| `default` | Default | `Default::default()` |
| `static-lifetime` | Static lifetime | `&'static Type` |
| `split_for_impl` | Split for impl | `generics.split_for_impl()` |
| `de_serde_attr` | Serde attr | `#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]` |
| `ANCHOR` | Anchor | `// ANCHOR: name ... // ANCHOR_END: name` |
| `flume` | Flume channels | `let (tx, rx) = flume::unbounded();` |
| `profile-function` | Profile function | `profile_function!();` |
| `profile-scope` | Profile scope | `profile_scope!("name");` |
| `with` | With builder | `pub fn with_field(&mut self, value: Type) -> &mut Self { self.field = value; self }` |

## Markdown Snippets

| Trigger | Description | Example Output |
|---------|-------------|----------------|
| `doc-link` | Docs.rs link | `[text](https://docs.rs/crate/version)` |
| `code-include` | Rust code include | ````rust\n{{{ #include file }}}\n``` |

## Additional Notes

- All snippets support tabstops for navigation (e.g., `$1`, `$2`).
- Friendly-snippets provides extensive additional snippets for many languages.
- Snippets are triggered via completion in insert mode.
- For Rust, logging snippets dynamically detect the logging crate (tracing vs log) based on project usage.

## Maintenance

This file is automatically maintained. When new snippets are added or modified, update this document accordingly.