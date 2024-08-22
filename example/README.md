# Using arb_merge

How to use arb_merge to merge multiple language files into a single ARB format file.

## Input Files

Suppose we have the following directory structure containing language files:

```text
.
└── example/
    ├── merged/
    ├── primarySource/
    │   ├── en.arb
    │   └── intl_french.arb
    |   ├── nestedFolder/
    |   |    └── more_translations_english.json
    └── secondarySource/
        ├── intl_en.arb
        └── intl_fr.arb
```

#### Contents of example/primarySource/en.arb

```json
{
  "@@locale": "en",
  "hello": "Hello"
}
```

#### Contents of example/primarySource/nestedFolder/more_translations_english.json

```json
{
   "@@locale": "en",
   "howDoYouDo": "How do you do?"
 }
```

#### Contents of example/secondarySource/intl_en.arb

```json
{
  "@@locale": "en",
  "one": "one",
  "two": "two",
  "three": "three"
}
```

## Using arb_merge

To merge these files using arb_merge, follow these steps:

1. Execute arb_merge:

    dart run arb_merge --sources example/primarySource,example/secondarySource --destination example/merged --pattern intl_{lang}.arb --sort

2. Verify Output:
   After executing arb_merge, the directory structure will be updated as follows:

   ```text
    .
    └── example/
        ├── merged/
        |   ├── intl_en.arb
        │   └── intl_fr.arb
        ├── primarySource/
        │   ├── en.arb
        │   └── intl_french.arb
        |   ├── nestedFolder/
        |   |    └── more_translations_english.json
        └── secondarySource/
            ├── intl_en.arb
            └── intl_fr.arb
    ```

### Output ARB Files

Contents of `intl_en.arb`:

```json
{
  "@@locale": "en",
  "hello": "Hello {name}!",
  "@hello": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "howDoYouDo": "How do you do?",
  "one": "one",
  "three": "three",
  "two": "two"
}
```

Contents of `intl_fr.arb`:

```json
{
  "@@locale": "fr",
  "hello": "Salut {name}!",
  "@hello": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "howDoYouDo": "Comment ça va?",
  "one": "un",
  "three": "trois",
  "two": "deux"
}
```

