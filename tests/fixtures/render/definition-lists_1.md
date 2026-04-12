:FnlCompileBuffer

:   Compiles current active fennel buffer

:FnlCompile[!]

:   Diff compiles all indexed fennel files
    If bang! is present then forcefully compiles all `source` files

:Fnl {expr}

:    Executes and Evalutate {expr} of fennel

     ```fennel
     :Fnl (print "Hello World")

     :Fnl (values some_var)
     ```

     Testing
