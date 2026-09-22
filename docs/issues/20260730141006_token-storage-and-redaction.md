# Token storage and redaction

## Decisions

OAuth configuration writes use a same-directory temporary file created with mode 0600 and an atomic rename. Existing configuration files are tightened to mode 0600.

Verbose output recursively redacts token, authorization, secret, and credential fields. OAuth request details do not print access or refresh tokens. HTTP clients use finite open and read timeouts.

## Effects

Access and refresh tokens are no longer left readable by other local users under a permissive umask, and nested secrets no longer leak through verbose response output. Network calls also have a bounded failure time.

Behavioral tests cover new and existing file permissions, recursive redaction, OAuth verbose output, and configured timeouts. The complete make test command passed.

## Next

- Prefer an operating-system credential store if the CLI later gains a portable secret-storage abstraction.
- Keep new response fields inside the recursive redaction path.

## Source

- lib/timely-app/cli.rb
- lib/timely-app/client.rb
- spec/timely-app/cli_spec.rb
- spec/timely-app/client_spec.rb
