### 4.3.0 (Next)

* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Gate conditional `:if`/`:unless` validator support behind a `.check_conditions` method - [@johnnyshields](https://github.com/johnnyshields).
* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Raise informative error if conditional `:if`/`:unless` validator is used with a class subject - [@johnnyshields](https://github.com/johnnyshields).
* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Support Arrays and Procs with non-zero arity for `:if`/`:unless` validator - [@johnnyshields](https://github.com/johnnyshields).
* [#248](https://github.com/mongoid/mongoid-rspec/pull/248): Add frozen_string_literal: true to all files and enforce rubocop - [@johnnyshields](https://github.com/johnnyshields).
* [#248](https://github.com/mongoid/mongoid-rspec/pull/248): Various small CI fixes - [@johnnyshields](https://github.com/johnnyshields).
* [#247](https://github.com/mongoid/mongoid-rspec/pull/247): Migrate to danger-pr-comment workflow - [@dblock](https://github.com/dblock).
* Your contribution here.

### 4.2.0 (2024/06/04)

* [#239](https://github.com/mongoid/mongoid-rspec/pull/239): Add support for `:if`/`:unless` validator options - [@knovoselic](https://github.com/knovoselic).
* [#244](https://github.com/mongoid/mongoid-rspec/pull/244): Migration from TravisCI to GitHub Actions - [@skalibog](https://github.com/skalibog).
* [#245](https://github.com/mongoid/mongoid-rspec/pull/245): Add support for Mongoid 9 - [@saisrinivasan](https://github.com/SairamSrinivasan).
* [#246](https://github.com/mongoid/mongoid-rspec/pull/246): Add support for touch options - [@saisrinivasan](https://github.com/SairamSrinivasan).

### 4.1.0 (2020/06/12)

* [#221](https://github.com/mongoid/mongoid-rspec/pull/221): Support `ordered_by` for Mongoid 5 and earlier - [@stim371](https://github.com/stim371).
* [#222](https://github.com/mongoid/mongoid-rspec/pull/222): Do not depend on `rspec` meta gem - [@lucasmazza](https://github.com/lucasmazza).
* [#231](https://github.com/mongoid/mongoid-rspec/pull/231): Fix transform_values deprecation in rails 6 - [@yads](https://github.com/yads).
* [#223](https://github.com/mongoid/mongoid-rspec/pull/223): Add support for `optional` in relations matchers - [@javierav](https://github.com/javierav).
* [#226](https://github.com/mongoid/mongoid-rspec/pull/226): Fix #217. Use Appraisal to test the gem - [@javierav](https://github.com/javierav).

### 4.0.1 (2018/06/15)

* [#212](https://github.com/mongoid/mongoid-rspec/pull/212): Mongoid 7 support - [@madAle](https://github.com/madAle).
* [#211](https://github.com/mongoid/mongoid-rspec/pull/211): Added `validate_absence_of` matcher - [@pedroadame](https://github.com/pedroadame).

### 4.0.0 (2018/01/29)

* [#197](https://github.com/mongoid/mongoid-rspec/pull/197): Mongoid 6 support - [@saumyamehta17](https://github.com/saumyamehta17), [@zeitnot](https://github.com/zeitnot).
* [#205](https://github.com/mongoid/mongoid-rspec/pull/205): Added Danger, PR linter - [@dblock](https://github.com/dblock).
* [#205](https://github.com/mongoid/mongoid-rspec/pull/205): Added RuboCop, ruby-style linter - [@dblock](https://github.com/dblock).

### 3.0.0 (2015/09/16)

* Support for released Mongoid 5.0.0 - [@rodrigopinto](https://github.com/rodrigopinto).

### 2.2.0 (2015/03/10)

* Support `with_message` option for `validate_confirmation_of` matcher - [@nitinstp23](https://github.com/nitinstp23).
* Updated RSpec dependency - [@rodrigopinto](https://github.com/rodrigopinto).

### 2.1.0 (2015/02/01)

* Added `be_dynamic_document` matcher - [@karmi](https://github.com/karmi).
* Added `with_counter_cache` relation matcher option - [@karmi](https://github.com/karmi).
* Fixed camelcased index options bug - [@karmi](https://github.com/karmi).
* Removed code related to Mongoid 3 - [@karmi](https://github.com/karmi).

### 2.0.0 (2015/01/05)

* Mongoid 4 support - [@rodrigopinto](https://github.com/rodrigopinto).
* Updated gem dependencies - [@rodrigopinto](https://github.com/rodrigopinto).
* Travis CI now only tests against Mongoid 4.0.X - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.13.0 (2015/01/05)

### 1.11.0 (2014/02/15)

### 1.10.0 (2013/12/07)

### 1.9.0 (2013/08/11)

* Added Association.cyclic and .stored_as matchers - [@johnnyshields](https://github.com/johnnyshields).

### 1.8.2 (2013/05/24)

* Support for detailed ordered_by matcher on associations - [@taiki45](https://github.com/taiki45).
* Modified HaveValidationMatcher to detect correct validator when more than one `:on` option is used - [@taiki45](https://github.com/taiki45).

### 1.8.1 (2013/05/03)

* Added ability to check custom message for length of validation - [@asynchrony](https://github.com/asynchrony).
* Extracted `with_message` logic to common module - [@asynchrony](https://github.com/asynchrony).

### 1.8.0 (2013/04/21)

* Added support for `:order` on associations - [@nanocity](https://github.com/nanocity).

### 1.7.0 (2013/02/27)

* Added `autobuild` matcher for `has_one` and `embeds_one` associations - [@bernardeli](https://github.com/bernardeli).
* Removed test options of matcher `accepts_nested_attributes_for` - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.6.0 (2013/01/27)

* Added `accept_nested_attributes_of` matcher - [@rodrigopinto](https://github.com/rodrigopinto).
* Added macro to check if field is localized - [@ph](https://github.com/ph).
* Fixed `with_default_value` to work when `:default` is not set on a field - [@kareemk](https://github.com/kareemk).
* Symbolize keys for Index Matcher - [@jtescher](https://github.com/jtescher).

### 1.5.6 (2013/01/13)

* Ensuring that specs fail if a particular option is not present while indexing - [@anshulm](https://github.com/anshulm).

### 1.5.5 (2012/11/28)

* Added Travis CI build image - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.5.4 (2012/08/20)

* Added support for matching document field aliases - [@dwbutler](https://github.com/dwbutler).
* Bug fix for inclusion matcher - [@dwbutler](https://github.com/dwbutler).

### 1.5.3 (2012/08/20)

### 1.5.1 (2012/07/27)

* Support for `Proc` in inclusion matcher - [@c0va23](https://github.com/c0va23).
* Allow more specific timestamp specs - [@zenzike](https://github.com/zenzike).
* Allow validations to pass if `:on` is not specified but spec specifies `:create`, `:update`, or both - [@zenzike](https://github.com/zenzike).

### 1.5.0 (2012/07/27)

* Mongoid 3.0 support - [@rodrigopinto](https://github.com/rodrigopinto).
* Added `allow_mass_assignment_of` matcher - [@rodrigopinto](https://github.com/rodrigopinto).
* Added matcher for custom validation - [@rodrigopinto](https://github.com/rodrigopinto).
* Added matcher for `validate_acceptance_of` - [@nanocity](https://github.com/nanocity).
* Added exclusion matcher - [@rodrigopinto](https://github.com/rodrigopinto).
* Support for RSpec > 2.9 - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.4.6 (2012/06/13)

* Fixed copy-paste typo in `uniqueness_of` - [@nessche](https://github.com/nessche).
* Fixed collection matcher to support Mongoid 3.0.0 - [@rodrigopinto](https://github.com/rodrigopinto).
* Changed index syntax to support Mongoid 3.0.0.rc - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.4.5 (2012/05/23)

### 1.4.4 (2011/06/02)

* Fixed HaveFieldMatcher for `Boolean` fields with default values - [@evansagge](https://github.com/evansagge).
* Fixed document extension matchers for RSpec 2.6 - [@evansagge](https://github.com/evansagge).

### 1.4.3 (2011/06/02)

* Updated gem dependencies - [@evansagge](https://github.com/evansagge).
* Fixed matcher descriptions for `be_mongoid_document`, `be_versioned_document`, `be_timestamped_document`, `be_paranoid_document` - [@evansagge](https://github.com/evansagge).

### 1.4.2 (2011/04/22)

* Changed mongoid version requirement to ~> 2.0 - [@evansagge](https://github.com/evansagge).
* Added `with_autosave` option to association matcher - [@MattVonVielen](https://github.com/MattVonVielen).
* Added `many` relations support the `inverse_of` option - [@nickhoffman](https://github.com/nickhoffman).

### 1.4.1 (2011/03/02)

* Added `be_stored_in` matcher to verify if a document has `store_in` `:collection_name` set - [@rodrigues](https://github.com/rodrigues).
* Added `less_than` verification to `validates_numericality_of` matcher - [@rodrigues](https://github.com/rodrigues).
* Added ability to test `dependent` option - [@sarcilav](https://github.com/sarcilav).
* Allows `embedded_in` argument to map to a name rather than a class for better decoupling - [@candlewaster](https://github.com/candlewaster).
* Handled `validate_numericality_of` options `:equal_to`, `:greater_than`, `:greater_than_or_equal_to`, `:less_than`, `:less_than_or_equal_to`, `:even`, `:odd`, `:only_integer`, `:allow_nil` - [@candlewaster](https://github.com/candlewaster).

### 1.3.2 (2010/11/10)

* Added within range check for `validate_length_of` matcher - [@pranas](https://github.com/pranas).
* Added `greater_than` check for `validate_numericality_of` matcher - [@pranas](https://github.com/pranas).
* Added `validates_confirmation_of` matcher - [@jnshashank](https://github.com/jnshashank).

### 1.2.1 (2010/08/24)

* Added support for association `ReferencesManyAsArray` - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.2.0 (2010/08/02)

* Fixing compatibility issues with Mongoid v2.0.0.beta.15 and up - [@evansagge](https://github.com/evansagge).
* Removed dependency on Rails - [@evansagge](https://github.com/evansagge).

### 1.1.2 (2010/06/07)

* Added requires for mongoid/associations - [@durran](https://github.com/durran).

### 1.1.1 (2010/06/01)

* Fixed association matchers - [@durran](https://github.com/durran).

### 1.1.0 (2010/06/01)

* Updated to be compatible with `ReferencesMany`, `ReferencesOne`, and `ReferenceIn` - [@durran](https://github.com/durran).

### 1.0.4 (2010/05/23)

* Updated gemspecs to be compatible with newer versions of Mongoid - [@durran](https://github.com/durran).

### 1.0.3 (2010/05/08)

* Initial public release - [@evansagge](https://github.com/evansagge).
