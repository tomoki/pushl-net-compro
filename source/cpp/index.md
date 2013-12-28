% 競技プログラミングの為のC++入門
% Tomoki Imai

# Introduction
ここでは、競技プログラミングをする為のC++について書く。
通常のプログラミングでは使用するべきではない書き方も多用する。
C++を使うメリットとしては、高速であること、使用している人が多いことが挙げられる。

## 前提知識
この文書を読むにあたっての前提知識を列挙する。

- 基本的なC/C++の知識。すくなくともCで関数定義等はできることを仮定する
- g++/clang++がインストールされていること

## リファレンス
上記の前提知識、およびこの文書でカバーしない場所を参照する文書を紹介する。

- [Windows で競技プログラミングしよう](http://d.hatena.ne.jp/torus711/20130516/p1)
- [Programming Place C++編](http://www.geocities.jp/ky_webid/cpp/language/index.html)

## 環境
下記のソースは、Linux上のg++4.8.2においてテストしている。

# コンパイルの仕方
manを読む。と言いたいところだが、いくつか注意点がある。

## C++11について
C++11はC++の比較的新しいバージョンである。
競技プログラミングのサイト(AOJ,Codeforces,TopCoder...)は基本的にC++11をサポートしている。
が、いくつかのサイト(POJ...)はC++11をサポートしていない。
この文書では、C++11をつかうことを前提とする。
理由としては、大分C++11をサポートするサイトが多くなってきたこと、C++11はかなり強力であることである。

## コンパイルオプション
g++/clang++は膨大なコンパイルオプションを備えている。ここでは有益なもののみを示す。

- -O2 : 最適化をオンにする。-O3もあるが、基本的には-O2で良いと思われる(要調査)
- -Wall : 普通のコードにおけるオプション警告をすべてオンにする
- -std=c++11 : C++11でコンパイルする。これなしだとC++03になる。また、c++0xと書く人もいるが、非推奨である。

これらをつけてコンパイルするべきである。具体的には以下のようにする。

~~~~~~
$ g++ -std=c++11 -Wall -O2 main.cpp -o main
~~~~~~

これを走らせると、ディレクトリにmainという実行ファイルが生成される。

## Aliasを設定する
Unixシステムにはコマンドを新しく設定するaliasという機能が存在する。
詳しくは"man alias"を参照してほしい。
私は以下のようなaliasを設定している。aliasの設定方法については検索してほしい。

~~~~~~
alias gpp="g++ -std=c++11 -Wall -O2"
~~~~~~

これによって、以下のような記述ができるようになる。

~~~~~~
$ gpp main.cpp -o main
~~~~~~

## コマンドの実行
(必要か?)

# C++の基本

## main関数
main関数は、C,C++でほとんど変わらない。
ただし、return 0を忘れるとruntime errorとなる場合がある。(例えばAOJ)
いわゆるHelloWorldは以下のように書ける。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    cout << "Hello World" << endl;
    return 0;
}
~~~~~~

## includeについて
多くの入門サイトにおいて、おまじないと称されるincludeについてすこしだけ。
競技プログラミングにおいて、ファイルを分割することはほとんどない。
なぜなら、ファイルの提出は1ファイルのみであることが多いからである。

しかしながら、iostreamのincludeが実際には何をしているのか知っておくのは有益である。
g++にオプション,-Eを設定することでプリプロセス済のファイルを出すことができる。
それによりincludeが何をしているのかわかるかもしれない。

includeとは、ファイルのコピペである。
includeは指定されたファイルをそこにペーストするだけにすぎない。
そのファイルの中に、coutだったりの定義がはいっているのである。

## using namespace
名前空間は、C言語には明示的には存在しない概念である。
C++において、名前空間は以下のように定義できる。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

namespace hoge{
    int poyo(int x){
        return x;
    }
};

int main(int argc,char **argv){
    // compile error
    // poyo was not declared in this scope
    // poyo(1);

    // ok
    hoge::poyo(1);
    return 0;
}
~~~~~~

つまるところ、Cのスコープのようなものである。
ただし、中の関数、変数にアクセスできる。それには上記のように(hoge::)が必要になる。
当然、標準ライブラリが持っている名前空間というものも存在していて、それがstdである。
using namespace ...は指定した名前空間をすべて取り込む。
よって、本来std::coutと書くところをcoutと省略することができる。
競技プログラミングをする上で、using namespace stdは必須であると言える。
通常のプログラミングでは名前の衝突が起こる可能性が高く、オススメできない。

また、coutについては後々書くことにする。

## 制御文
制御文はアルゴリズムの根本と言っても良い。
基本的にはCと同じであるが、例を紹介しながらさらっと見ていく。

### if文
Cのifと大体同じである。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

struct Hoge{
    explicit operator bool() const{
        cerr << "bool cast" << endl;
        return true;
    }
};

int main(int argc,char **argv){
    Hoge h;
    if(h){
        cerr << "h is true" << endl;
    }else{
        cerr << "h is false" << endl;
    } // -> h is true

    if(0){
        cerr << "0 is true" << endl; 
    }else{
        cerr << "0 is false" << endl;
    } // -> 0 is false
    return 0;
}
~~~~~~

boolへのキャストが発生する。整数型(int,long long)は0のみがfalse,それ以外はtrueと解釈される。
クラスの場合は、boolへのキャストが発生する。

### 通常のfor文
Cのforと大体同じである。が、C90と違って宣言をfor文内で行える。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    for(int i=0;i<10;i++){
        cout << i << endl;
    }
    return 0;
}
~~~~~~

また競技の世界では以下のようなマクロを宣言することが多い。

~~~~~~{.cpp}
#include <iostream>

#define rep(i,n) for(int i=0;i<(int)(n);i++)

using namespace std;

int main(int argc,char **argv){
    rep(i,10){
        cout << i << endl;
    }
    return 0;
}
~~~~~~

これによって、インクリメントや条件文のミスを減らし、またタイプ量も減らすことができる。

### range-based for文
これについてはvector等と一緒に述べることにする。

### while文
Cと大体同じである。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    // 無限ループ
    while(true){
    }
    return 0;
}
~~~~~~

個人的には、複数テストケースのときに以下のように使うことが多い。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

// ここで解く
int solve(int n){
    return n;
}

int main(int argc,char **argv){
    // n=0のケースが来るまでループ
    while(true){
        int n;
        cin >> n;
        if(n == 0) break;
        cout << solve(n) << endl;
    }
    return 0;
}
~~~~~~

### do-while
Cのdo-whileとほとんど同じである。
競技の世界でも、通常の世界でもあまり目にすることはないが、競技の世界ではnext_permutationというライブラリ関数を使う際に使用することが多い。
ここでは省略するが、next_permutationについては以下を参照されたし。

- [cpprefjp - C++ Library Reference next_permutation](https://sites.google.com/site/cpprefjp/reference/algorithm/next_permutation)

## 変数
C++には型やクラス等が存在している。ここではC++特有のもののみ紹介する。
クラスはまた後で。

### const
いわゆる定数である。Cにはこれが存在せず、またconstは違う意味であった。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    const int n = 3;

    // コンパイルエラー
    n = 2;
    return 0;
}
~~~~~~

### 参照
参照とは、変数の実体を共有する変数を宣言する方法である。
別の名前を付けると言っても良い。
ある意味ポインタとおなじようなものである。(同じポインタを持つ違う変数)

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    int n = 3;
    int& p = n;

    // pを書き換える <-> nを書き換える
    p = 1000;
    cout << n << endl; // -> 1000
    return 0;
}
~~~~~~

後述するが、参照は競技プログラミングにおいて必須となる場面がある。

#### const参照
参照を定義するときにconstを付けることで書き換え不可能になる。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    int n = 3;
    const int& p = n;

    // コンパイルエラー
    p = 1000;
    return 0;
}
~~~~~~

### ポインタ
ポインタはC同様に存在する。またC++にはスマートポインタがある。

### auto
C++11にはautoという特殊な宣言が存在する。
これは型推論をして適当な型をそこに当て嵌めてくれるというものである。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int main(int argc,char **argv){
    int n = 3;
    // 右辺はintだから左辺もint
    auto p = n * 3;

    cout << p << endl;
    return 0;
}

~~~~~~

これだけだと特に便利さを感じないが、後々長い宣言が登場するときに便利なのである。


## 関数
Cとほとんど同じだが、いくつかC++において追加された機能が存在している。

### 通常の宣言

再帰的定義は特に何も書く必要はない。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

int fact(int n){
    if(n == 1 or n == 0) return 1;
    else return n * fact(n-1);
}

int main(int argc,char **argv){
    cout << fact(10) << endl;
    return 0;
}
~~~~~~

### 参照を引数にする
上で出てきた参照を引数にすることができる。
ここで、その参照を書き換えると元々の変数も書き変わることに注意。
参照は実体を共有する別名の変数なので、メモリを消費しない。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

void change(int& n){
    n = 3;
}

int main(int argc,char **argv){
    int n = 1000;
    change(n);

    cout << n << endl; // -> 3
    return 0;
}
~~~~~~

筆者の場合、参照を引数にするのは以下のようなケースである。

1. メモ化再帰のメモとして
2. 探索する際に盤面を渡す

ここではケース1についてサンプルのコードを載せる。

~~~~~~{.cpp}
#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

// メモ化なし
int fib_without_memo(int n){
    if(n == 0 or n == 1) return 1;
    return fib_without_memo(n-1) + fib_without_memo(n-2);
}

// メモあり
int fib_with_memo(int n,unordered_map<int,int> &memo){
    if(memo.find(n) != memo.end()) return memo[n];
    if(n == 0 or n == 1) return memo[n]=1;
    return memo[n] = fib_with_memo(n-1,memo) + fib_with_memo(n-2,memo);
}


int main(int argc,char **argv){
    unordered_map<int,int> memo;
    for(int i=0;i<10;i++){
        cout << fib_with_memo(i,memo) << endl;
    }
    return 0;
}
~~~~~~

もちろん、メモをグローバルな変数として宣言する方法もあるが、個人的には美しくないと感じる。
この方法では、テストケース毎にクリアしたい場合等に綺麗に書くことができる。


#### const参照を引数にする
どちらかと言えば、こちらのほうが安全だろう。
メモリは節約したいが、書き換えられると嫌なときに使う。
巨大なデータを渡すときには必須。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

void change(const int& n){
    // コンパイルエラー
    n = 3;
}

int main(int argc,char **argv){
    int n = 1000;
    change(n);

    cout << n << endl; // -> 3
    return 0;
}
~~~~~~

## クラス
C++にはJavaやPython等の言語と同様にクラスと呼ばれるものが存在する。
クラスの意義についてはここでは深くは触れず、使い方のみを説明することにする。
競技において、クラスを必要とする場面は実は多い。ただし、継承を使う場面はあまりない(もしくは著者が理解していない)ので、その説明は省く。

### 宣言
クラスの宣言について説明する。
宣言には、class,もしくはstructキーワードを用いる。
この二つの違いについてはまた後で。

~~~~~~{.cpp}
#include <iostream>

using namespace std;

// 例えばグラフのノードを表す構造を作りたい。
//  structはCの構造体ではない
struct Edge{
    // structの場合デフォルトでpublic
    int src,dst;
    // 初期化リストをつかって変数を初期化
    Edge(int s,int d) : src(s),dst(d){
    }
};

int main(int argc,char **argv){
    Edge n(1,2);
    cerr << n.src << " " << n.dst << endl;
    return 0;
}
~~~~~~

グラフのノードを表すクラスを作成した。
structで宣言すると、メンバーのデフォルト属性がpublicとなるが、競技の世界ではそのほうが都合が良い。
とりあえずstructで宣言すればOK。privateにする必要はない。
通常、デストラクタ等も書くべきだが、競技をする上ではあまり必要ないだろう。(クラスの中で動的にメモリ確保をしていなければ)


### テンプレートクラス
競技プログラミングにおいて自分でテンプレートをつかうクラスを作る事はすくない。
しかしながら、標準ライブラリを使う上でテンプレートを使っていくので、ここですこしだけ書いておく。
テンプレートクラスは一部でcharやintといった型を明示せずに抽象的な型を使ってクラスを定義する。

~~~~~~{.cpp}
#include <iostream>

using namespace std;


// Tを抽象的な型としておく。
template<typename T>
struct Edge{
    int src,dst;
    T value;
    Edge(int s,int d,T v) : src(s),dst(d),T(v){
    }
};

int main(int argc,char **argv){
    // T = intとする
    Edge<int> e(1,2,3);
    cerr << e.src << " " << e.dst << " " << e.value << endl;
    return 0;
}
~~~~~~

上記はEdgeのvalueをTという型で置いておいて、mainの中でTはintとしている。

###
