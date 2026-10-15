# Releasing Mongoid::RSpec

## Prepare

Use the upstream checkout on a clean `master`, verify `origin` points to `mongoid/mongoid-rspec`, and run `git pull --ff-only`. Check the latest [GitHub Actions](https://github.com/mongoid/mongoid-rspec/actions) results for supported platforms. Use patch versions for fixes, minor versions for backward-compatible features, and major versions for breaking changes.

Set the version in `lib/mongoid/rspec/version.rb`, date its changelog section using `YYYY/MM/DD`, and remove that section's contribution placeholder.

```sh
bundle install
bundle exec rake
bundle exec rubocop
git add CHANGELOG.md lib/mongoid/rspec/version.rb RELEASING.md
git commit -m "Preparing for release, 4.4.0."
git push origin master
```

Do not wait for the preparation commit's CI checks before publishing.

## Publish RubyGems and GitHub

```sh
bundle exec rake release
```

Complete RubyGems MFA when requested. The task builds the gem, pushes its tag, and publishes to RubyGems. If interrupted, inspect the existing tag and gem version before retrying. Never move a published tag. If only gem publication is missing, use `gem push pkg/mongoid-rspec-4.4.0.gem`.

Creating the tag does not create a GitHub release. After verifying RubyGems publication, publish a matching GitHub release with the changelog entries:

```sh
version=4.4.0
notes="$(mktemp)"
awk -v version="$version" '
  /^### / {
    if (found) exit
    if ($2 == version) found = 1
    next
  }
  found { print }
' CHANGELOG.md > "$notes"
gh release create "v$version" --repo mongoid/mongoid-rspec --verify-tag --title "$version" --notes-file "$notes" --latest
rm "$notes"
curl --fail --silent --show-error "https://rubygems.org/api/v2/rubygems/mongoid-rspec/versions/$version.json"
gh release view "v$version" --repo mongoid/mongoid-rspec
```

Both the published gem and non-draft GitHub release must be verified.

## Prepare the Next Version

Increment the development patch version in `lib/mongoid/rspec/version.rb`, for example to `4.4.1`. Add `### 4.4.1 (Next)` and a contribution placeholder above the released changelog section. Commit and push those changes to `master`, leaving the released tag unchanged.
