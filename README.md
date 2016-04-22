# transit-julia

Note that transit-julia is still under active development and is *not* ready for use.

Transit is a data format and a set of libraries for conveying values between applications written in different languages. This library provides support for marshalling Transit data to/from [Julia](http://julialang.org).

* [Rationale](http://blog.cognitect.com/blog/2014/7/22/transit)
* [Specification](http://github.com/cognitect/transit-format)

This implementation's major.minor version number corresponds to the version of the Transit specification it supports.

Currently only the JSON formats are implemented.
MessagePack is **not** implemented yet. 

_NOTE: Transit is a work in progress and may evolve based on feedback. As a result, while Transit is a great option for transferring data between applications, it should not yet be used for storing data durably over time. This recommendation will change when the specification is complete._

## Usage

Reading data with transit-julia involves...

```julia
TBD
```

Writing is similar:

```julia
TBD
```


## Default Type Mapping

Really this is all TBD at this point.

| Semantic Type | write accepts | read produces |
|:--------------|:--------------|:--------------|
| null| anything of type Void | Void() |
| string| string | string |
| boolean | Bool | Bool |
| integer, signed 64 bit| any signed or unsiged int type | Int64 |
| floating pt decimal| Float32 or Float64 | Float64 |
| bytes| Array{Int8} | Array{Int8} |
| keyword | Symbol | Symbol |
| symbol | Transit.TSymbol | Transit.TSymbol
| arbitrary precision decimal| BigFloat | BigFloat |
| arbitrary precision integer| BigInt | BigInt |
| point in time | TBD | TBD |
| point in time RFC 33339 | TBD | TBD |
| uuid | Base.Random.UUID| Base.Random.UUID|
| uri | Transit.TURI | Transit.TURI |
| char | Char | Char |
| special numbers | Inf, Nan| Inf, Nan
| array | arrays | Any[] |
| map | Dict | Dict{Any,Any} | 
| set |  Set | Set{Any} |
| list | DataStructures.Cons | DataStructures.Cons |
| map w/ composite keys |  Dict{Array,Any} |  Dict{Array,Any} |
| link | Transit.TLink | Transit.TLink |


## Copyright and License
Copyright © 2016 Russ Olsen, Ben Kamphaus

This library is a Julia port of the Java and Ruby versions created and maintained by Cognitect, therefore

Copyright © 2014 Cognitect

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

This README file is based on the README from transit-csharp, therefore:

Copyright © 2014 NForza.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
