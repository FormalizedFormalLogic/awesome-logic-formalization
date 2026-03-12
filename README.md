# Awesome Logic Formalization

Bibliography of formalization/mechanization mainly related mathematical logic.

## Contributing

### HTML Generate

We use generate HTML file by [Deno](https://deno.com/).

```shell
deno run --allow-read --allow-write ./generate.ts
```

### Preview

Host `/output`.
Example using [miniserve](https://github.com/svenstaro/miniserve):

```shell
miniserve output --index index.html
```
