# Change Log

All notable changes to this project will be documented in this file.

<a name="0.2.0"></a>
# [0.2.0](https://github.com/Tabcorp/swift-EnrichedText/compare/0.1.0...0.2.0) (2018-06-07)

- Enforce strict command nesting
- Optimise performance for the case where closing tags are cased the same as their opening tag
- Treat param commands case-insensitively
- Support all font alteration commands in the RFC


<a name="0.1.0"></a>
# 0.1.0 (2018-05-25)

- Full support for the specification, but only a subset of formatting commands are supported
- Supported Formatting Commands
  - Bold
  - Italic
  - Underline
- Strict nesting is not validated
- There are some obvious avenues for performance improvement; but overall performance is not poor