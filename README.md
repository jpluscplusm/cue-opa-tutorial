# cue-opa-tutorial

A translation of
https://www.openpolicyagent.org/docs/latest/terraform/#getting-started into
non-idiomatic CUE.

## Usage

```
$ cue eval -e '#authz' .:policy -l tfplan: \
    success.original-tf-plan.json
true
$ cue eval -e '#authz' .:policy -l tfplan: \
    success.additional-no-op-iam-change.json
true
$ cue eval -e '#authz' .:policy -l tfplan: \
    failure.contains-iam-change.json
false
```
