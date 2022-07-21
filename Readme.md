# Replacing modules in go with forked ones

## TL;DR

This repo is a simple demonstration on how to replace go modules with forked
versions.
In simple lines:
1. Fork original module
2. Do your changes, but preserve package names. Ideally keep the same repo 
name - since forks are tipically done between different organizations, the last
URI portion should remain the same, thus module system should not complain about it.
3. In your app go.mod (the one *CONSUMING* the modules), add a `replace` statement.
4. Profit.

## Long History

In a real world sometimes we just cant reuse an existing module, but we may need
to adapt it. To allow it to happen in a proper way, some details shall be 
observed.

We will use two modules for this example, and also this one, which is the application consuming them.

- [go-module-replace-a](https://github.com/paulosimao-ardanlabs/go-module-replace-a)
- [go-module-replace-b](https://github.com/paulosimao-ardanlabs/go-module-replace-b)

Module `go-module-replace-a` is the original one we *WANT TO REPLACE*. Module `go-module-replace-b` is the new one we forked, and that we want `go-module-replace-a` to be *REPLACED WITH*.

### 1 - Forking the module

Tipically, modules will be forked between different organizations, so lets say,
you will fork `github.com/original-org/module` to `github.com/my-org/module`, 
and this is perfectly fine. Since we are keeping the last portion of our URI 
the same (both are `module`), go should not have any concerns about it.
Once forked, business as usual - adapt your code accordingly.
 > IMPORTANT: Since I decided making this example with both repos under the same organization, I could not use the same module name - reason why we ended up with `go-module-replace-a` and `go-module-replace-b`. Important to note here is: `go-module-replace-b` declares itself in code as `gomodulereplacea` in go code. The key change is at go.mod file. In `go-module-replace-b`, it must match the repo URL, but in the go.mod of our application, the `replace` directive will fix it.

### 2 - Now adapting your app

Initially we should consider that the proposed change would require us to change
each and every import in our application. But the replace directive comes to our 
rescue here, allowing easier transition.

```
replace github.com/paulosimao-ardanlabs/go-module-replace-a => github.com/paulosimao-ardanlabs/go-module-replace-b v0.0.0-20220721083559-e84c266793ea
```

In the snippet above we are telling go: "Whenever you see `github.com/paulosimao-ardanlabs/go-module-replace-a`, please use `github.com/paulosimao-ardanlabs/go-module-replace-b` - and by the way, I want it version `v0.0.0-20220721083559-e84c266793ea`"

You can see the full example in the go.mod file in this repo.

In order to get the version label correctly, you can do a go get `<module>@<commit hash>`, and this will be included as a traditional require in your go.mod, like this:

`go get github.com/paulosimao-ardanlabs/go-module-replace-b@e84c266793ea0c752c469bb52f066c273e338e2e`

Which will add the following line to your go.mod

```
require github.com/paulosimao-ardanlabs/go-module-replace-b v0.0.0-20220721083559-e84c266793ea // indirect
```
Now we can change it to: 

```
replace github.com/paulosimao-ardanlabs/go-module-replace-a => github.com/paulosimao-ardanlabs/go-module-replace-b v0.0.0-20220721083559-e84c266793ea
```

Then we run `go mod tidy` and the following line will be added to go.mod:

```
require github.com/paulosimao-ardanlabs/go-module-replace-a v0.0.0-00010101000000-000000000000
```
> Please remember: the go mod tidy worked like this because we did not touch our code, it is still referring to the original module. Our `main.go` has always been pointing to module `go-module-replace-a` with `import "github.com/paulosimao-ardanlabs/go-module-replace-a"`

Now if we run our app, we will see that the code in `go-module-replace-a` is being called, although except for go.mod, everything else is referring to `go-module-replace-a`.

And thats it!

See ya! 😃


