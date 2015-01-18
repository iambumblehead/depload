depload
=======
[MIT-license](#license)

### OVERVIEW:

`depload:ensure_all/1` to load OTP dependencies used by your application.

How I use it in the start an application:
```erlang
depload:ensure_all(your_app).    % ok.
application:load(your_app).      % ok.
depload:start_app_deps(your_app) % ok.
```

functions defined here are from [couchbeam sources][6]. They exist there under MIT License credited to Justin Sheehy and Andy Gross of Basho. They are generally useful to me and so are collected here in one module.

[0]: http://www.bumblehead.com "bumblehead"
[4]: http://www.erlang.org/doc/apps/edoc/chapter.html "edoc"
[5]: https://github.com/rebar/rebar "rebar"
[6]: https://github.com/benoitc/couchbeam/blob/master/src/couchbeam_deps.erl "couchbeam"


---------------------------------------------------------

 1. Compile
 
    ```bash
    $ rebar compile
    ```
 2. EDoc
 
    ```bash
    $ rebar doc
    ```
 3. Dialyzer, build 'persistent lookup table', then run dialyzer or typer
 
    ```bash
    $ dialyzer # dialyzer with no options to see examples
    $ dialyzer --build_plt --apps erts kernel stdlib
    $ dialyzer src/depload.erl
    ```


---------------------------------------------------------
#### <a id="license">License:

![scrounge](http://github.com/iambumblehead/scroungejs/raw/master/img/hand.png) 

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
