### 4.4.0 (Next)

* [#209](https://github.com/mongoid/mongoid-rspec/issues/209): Document and integration-test scoped matchers for mixed Mongoid and ActiveRecord applications using shoulda-matchers - [@dblock](https://github.com/dblock).
* [#210](https://github.com/mongoid/mongoid-rspec/issues/210): Support checking nil and blank options on length validators with `to_allow` - [@dblock](https://github.com/dblock).
* [#161](https://github.com/mongoid/mongoid-rspec/issues/161): Add have_and_belong_to_many_related as a nonconflicting alternative when using shoulda-matchers - [@dblock](https://github.com/dblock).
* [#220](https://github.com/mongoid/mongoid-rspec/issues/220): Add `.readonly` to field matchers for fields declared with `attr_readonly` - [@dblock](https://github.com/dblock).
* [#233](https://github.com/mongoid/mongoid-rspec/issues/233): Add `with_primary_key` for association matchers - [@dblock](https://github.com/dblock).
* [#235](https://github.com/mongoid/mongoid-rspec/issues/235): Remove deprecated RubyForge metadata from the gemspec - [@dblock](https://github.com/dblock).
* [#135](https://github.com/mongoid/mongoid-rspec/issues/135): Match requested length options against all applicable validators instead of only the first - [@dblock](https://github.com/dblock).
* [#252](https://github.com/mongoid/mongoid-rspec/pull/252): Fill in historical changelog entries and correct release attribution - [@dblock](https://github.com/dblock).
* Your contribution here.

### 4.3.0 (2026/10/14)

* [#251](https://github.com/mongoid/mongoid-rspec/pull/251): Add SimpleCov and Coveralls reporting in CI and update status badges - [@dblock](https://github.com/dblock).
* [#250](https://github.com/mongoid/mongoid-rspec/pull/250): Modernize CI actions and MongoDB startup while retaining Ruby 2.6–4.0, Mongoid 4–9, and MongoDB 4.4–8.0 coverage - [@dblock](https://github.com/dblock).
* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Gate conditional `:if`/`:unless` validator support behind a `.check_conditions` method - [@johnnyshields](https://github.com/johnnyshields).
* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Raise informative error if conditional `:if`/`:unless` validator is used with a class subject - [@johnnyshields](https://github.com/johnnyshields).
* [#249](https://github.com/mongoid/mongoid-rspec/pull/249): Support Arrays and Procs with non-zero arity for `:if`/`:unless` validator - [@johnnyshields](https://github.com/johnnyshields).
* [#248](https://github.com/mongoid/mongoid-rspec/pull/248): Add frozen_string_literal: true to all files and enforce rubocop - [@johnnyshields](https://github.com/johnnyshields).
* [#248](https://github.com/mongoid/mongoid-rspec/pull/248): Various small CI fixes - [@johnnyshields](https://github.com/johnnyshields).
* [#247](https://github.com/mongoid/mongoid-rspec/pull/247): Migrate to danger-pr-comment workflow - [@dblock](https://github.com/dblock).

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

### 2.3.0-rc0 (2015/08/30)

* [#155](https://github.com/mongoid/mongoid-rspec/pull/155): Support Mongoid 5.0.0.rc0 - [@bitaculous](https://github.com/bitaculous).

### 2.3.0-beta (2015/08/05)

* [#154](https://github.com/mongoid/mongoid-rspec/pull/154): Support Mongoid 5.0.0.beta - [@90yukke](https://github.com/90yukke).
* [#152](https://github.com/mongoid/mongoid-rspec/pull/152): Rename the gem specification to match the gem name - [@90yukke](https://github.com/90yukke).

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

### 2.0.0-rc1 (2014/09/24)

* [#125](https://github.com/mongoid/mongoid-rspec/pull/125): Add Mongoid 4 support, including updated index and inclusion matchers - [@phstc](https://github.com/phstc).
* Update matchers for the RSpec 3 expectation protocol, including `allow_mass_assignment_of` - [@francescobbo](https://github.com/francescobbo).

### 1.13.0 (2015/01/05)

* Update the RSpec dependency and replace the yanked 1.12.0 release - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.12.0 (2015/01/05)

* Support the RSpec 3 expectation protocol in [edb6b7c](https://github.com/mongoid/mongoid-rspec/commit/edb6b7c) - [@francescobbo](https://github.com/francescobbo).
* Fix `allow_mass_assignment_of` for RSpec 3 in [468ca92](https://github.com/mongoid/mongoid-rspec/commit/468ca92) - [@francescobbo](https://github.com/francescobbo).
* Yank this release in favor of 1.13.0 - [@rodrigopinto](https://github.com/rodrigopinto).
* Update gem dependency requirements to follow semantic versioning - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.11.0 (2014/02/15)

* [#116](https://github.com/mongoid/mongoid-rspec/issues/116): Normalize index options such as `dropDups` when matching `drop_dups` - [@rodrigopinto](https://github.com/rodrigopinto).
* Update the Mongoid dependency - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.10.0 (2013/12/07)

* [#115](https://github.com/mongoid/mongoid-rspec/pull/115): Explicitly require `rspec/expectations` - [@mukimov](https://github.com/mukimov).
* [#114](https://github.com/mongoid/mongoid-rspec/pull/114): Improve installation instructions - [@carloslopes](https://github.com/carloslopes).

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

### 1.5.3 (2012/08/20)

* [#78](https://github.com/mongoid/mongoid-rspec/pull/78): Fix the inclusion matcher when a `Proc` supplies the allowed values - [@c0va23](https://github.com/c0va23).

### 1.5.2 (2012/08/02)

* [#77](https://github.com/mongoid/mongoid-rspec/pull/77): Support `Proc` values in the inclusion matcher - [@c0va23](https://github.com/c0va23).
* Document validation, mass-assignment, and index matchers - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.5.1 (2012/07/27)

* Allow more specific timestamp specs - [@zenzike](https://github.com/zenzike).
* Allow validations to pass if `:on` is not specified but spec specifies `:create`, `:update`, or both - [@zenzike](https://github.com/zenzike).

### 1.5.0 (2012/07/27)

* Mongoid 3.0 support - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.4.6 (2012/06/13)

* [#70](https://github.com/mongoid/mongoid-rspec/pull/70): Add `allow_mass_assignment_of` - [@rodrigopinto](https://github.com/rodrigopinto).
* [#68](https://github.com/mongoid/mongoid-rspec/pull/68): Add a custom validation matcher - [@nessche](https://github.com/nessche).
* Fixed copy-paste typo in `uniqueness_of` - [@nessche](https://github.com/nessche).
* Fixed collection matcher to support Mongoid 3.0.0 - [@rodrigopinto](https://github.com/rodrigopinto).
* Changed index syntax to support Mongoid 3.0.0.rc - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.4.5 (2012/05/23)

* [#46](https://github.com/mongoid/mongoid-rspec/pull/46): Add `have_index` and the association `with_index` option - [@mstarkman](https://github.com/mstarkman).
* [#51](https://github.com/mongoid/mongoid-rspec/pull/51): Support ranges in the inclusion matcher - [@pericles](https://github.com/pericles).
* [#53](https://github.com/mongoid/mongoid-rspec/pull/53): Fix uniqueness scope matching for stringified values - [@rwz](https://github.com/rwz).
* [#55](https://github.com/mongoid/mongoid-rspec/pull/55): Add an exclusion validation matcher - [@noazark](https://github.com/noazark).
* [#60](https://github.com/mongoid/mongoid-rspec/pull/60): Fix the exclusion matcher description - [@frodsan](https://github.com/frodsan).
* [#61](https://github.com/mongoid/mongoid-rspec/pull/61): Update matchers for the Mongoid 3 API - [@kfaustino](https://github.com/kfaustino).
* [#64](https://github.com/mongoid/mongoid-rspec/pull/64): Support validation contexts with `:on` - [@yairgo](https://github.com/yairgo).
* [#65](https://github.com/mongoid/mongoid-rspec/pull/65): Add `validate_acceptance_of` - [@nanocity](https://github.com/nanocity).
* Support documents using `MultiParameterAttributes` - [@lparedes](https://github.com/lparedes).
* Support RSpec versions newer than 2.9 - [@evansagge](https://github.com/evansagge).

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
* Added `be_stored_in` matcher to verify if a document has `store_in` `:collection_name` set - [@rodrigues](https://github.com/rodrigues).
* Added `less_than` verification to `validates_numericality_of` matcher - [@rodrigues](https://github.com/rodrigues).
* Added ability to test `dependent` option - [@sarcilav](https://github.com/sarcilav).
* Allows `embedded_in` argument to map to a name rather than a class for better decoupling - [@candlewaster](https://github.com/candlewaster).
* Handled `validate_numericality_of` options `:equal_to`, `:greater_than`, `:greater_than_or_equal_to`, `:less_than`, `:less_than_or_equal_to`, `:even`, `:odd`, `:only_integer`, `:allow_nil` - [@candlewaster](https://github.com/candlewaster).

### 1.4.1 (2011/03/03)

* Regenerate the gem specification and update the dependency lockfile; no matcher changes since 1.4.0 - [@evansagge](https://github.com/evansagge).

### 1.4.0 (2011/03/03)

* Added within range check for `validate_length_of` matcher - [@pranas](https://github.com/pranas).
* Added `greater_than` check for `validate_numericality_of` matcher - [@pranas](https://github.com/pranas).
* Merge Mark Kendall's `validate_confirmation_of` matcher in [a898653](https://github.com/mongoid/mongoid-rspec/commit/a898653) - [@evansagge](https://github.com/evansagge).
* Add the association `with_foreign_key` matcher and additional length validation options - [@ches](https://github.com/ches).
* Support the Mongoid 2.0.0.rc API - [@durran](https://github.com/durran).
* Remove the `save` / `save_properly` matcher - [@durran](https://github.com/durran).

### 1.3.2 (2010/11/11)

* Regenerate the gem specification after the 1.3.0 and 1.3.1 packaging updates; no matcher changes - [@evansagge](https://github.com/evansagge).

### 1.3.1 (2010/11/11)

* Correct the generated gem version and restore the packaged dependency lockfile - [@evansagge](https://github.com/evansagge).

### 1.3.0 (2010/11/11)

* Upgrade to RSpec 2 and update dependencies - [@evansagge](https://github.com/evansagge).
* Add `validate_length_of` - [@jeyb](https://github.com/jeyb).
* Integrate Jiří Zajpt's document extension matchers in [7f87e60](https://github.com/mongoid/mongoid-rspec/commit/7f87e60) - [@evansagge](https://github.com/evansagge).
* Add `case_insensitive` and `with_message` options to the uniqueness matcher - [@coffeencoke](https://github.com/coffeencoke).

### 1.2.1 (2010/08/24)

* Added support for association `ReferencesManyAsArray` - [@rodrigopinto](https://github.com/rodrigopinto).

### 1.2.0 (2010/08/03)

* Fixing compatibility issues with Mongoid v2.0.0.beta.15 and up - [@evansagge](https://github.com/evansagge).
* Removed dependency on Rails - [@evansagge](https://github.com/evansagge).
* Explicitly require RSpec - [@shingara](https://github.com/shingara).
* Remove RSpec warnings - [@gmoeck](https://github.com/gmoeck).

### 1.1.2 (2010/06/08)

* Added requires for mongoid/associations - [@durran](https://github.com/durran).

### 1.1.1 (2010/06/02)

* Fixed association matchers - [@durran](https://github.com/durran).

### 1.1.0 (2010/06/02)

* Updated to be compatible with `ReferencesMany`, `ReferencesOne`, and `ReferenceIn` - [@durran](https://github.com/durran).

### 1.0.4 (2010/05/24)

* Updated gemspecs to be compatible with newer versions of Mongoid - [@durran](https://github.com/durran).

### 1.0.3 (2010/05/09)

* Regenerate the gem specification for version 1.0.3 - [@evansagge](https://github.com/evansagge).

### 1.0.2 (2010/05/09)

* Initial tagged implementation of document, field, association, and validation matchers - [@evansagge](https://github.com/evansagge).
