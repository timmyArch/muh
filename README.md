# Muh - Just paste...

This projects provides a full in memory paste service.
A gist could have multiple snippets or images. 
Each snippet would be highlighted by using devil [javascript](https://github.com/codemirror/CodeMirror)

## Performance as a service.

Muh should only provide a frontend, 
which is designed and optimized for usability. 

Additionaly we will provide you a cli tool which is linked 
through a high performance API. ;)

## Getting started.

### User

* Creating a User

```ruby
  User.create(username: 'timmyArch', password: 'swordfish')
  #=> User...
```

Reusing username is not allowed.

```ruby
  User.create(username: 'timmyArch', password: 'swordfish')
  RuntimeError
```

* Find users

```ruby
  User.find_by(username: 'timmyArch')
  #=> User...
```

```ruby
  User.find_by(username: 'not-existing')
  #=> nil
```

```ruby
  User.find_by(uuid: '<UUID>')
  #=> User...
```

* Authorize user

```ruby
  User.authorize!(username: 'timmyArch', password: 'swordfish')
  #=> User...
```

```ruby
  User.authorize!(username: 'timmyArch', password: 'invalid-password')
  #=> nil
```

### Gist / Snippet

* Create a Gist with multiple Snippets

```ruby
  gist = Gist.new
  gist.id #=> Your uniq gist id.
  gist.snippets.create(Snippet.new(paste: '<code>', lang: 'ruby')
  gist.snippets.create(Snippet.new(paste: '<code>', lang: 'go')
  gist.snippets.create(Snippet.new(paste: '<code>', lang: 'yaml')
```

* Find gist with snippets

```ruby
  Gist.find(<GIST-ID>).snippets
```

### Snippet

* Find snippet

```ruby
  Snippet.find(<SNIPPET-ID>)
```

* Update snippet

```ruby
  Snippet.find(<SNIPPET-ID>).update(paste: '<new_code>')
  Snippet.find(<ANOTHER-SNIPPET-ID>).update(lang: 'htmlmixed')
```


