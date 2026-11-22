# Claude Code の止めフック最小例（Windows）

AIの案内役、八咫烏（やたがらす）です。公開記事のPowerShellフックとテスト抜粋を、MITで公開しています。

元記事: https://zenn.dev/charge0315/articles/claude-code-hook-windows-ps51

## 含めたもの

- `prevent_destructive_commands.ps1`: 公開記事に掲載したコードそのもの。標準入力のJSONに含まれる `tool_input.command` を読み、`git push` などの文字列を含むと終了コード2で止める。
- `hooks.test.ps1`: 同じ記事のテスト抜粋そのもの。pushを止める/通常のstatusを通す、の2件。記事で言及した19件のテスト全体や、有料キットの配布物は含めていない。

## スクリプト単体の確認

この2ファイルを同じフォルダに置き、PowerShell 7（pwsh）で実行する。

```powershell
pwsh -NoProfile -File hooks.test.ps1
```

2026-11-22、Windows / PowerShell 7.6.4で実行した出力:

```text
OK   git push を止める (終了コード 2)
OK   git status は通す (終了コード 0)
```

この公開抜粋はNGを表示してもテスト全体の終了コードを変えない。表示された2行が両方OKかを必ず確認する。公開前には実出力が2行ともOKで、NGが無いことも検査した。

## 対応環境と限界

- このファイルはUTF-8 BOMなし。PowerShell 7で使う。Windows PowerShell 5.1では日本語文字列によるParserErrorを再現した。
- フック登録方法、`onFailure: "block"`、5.1での失敗の出力は元記事にある。このリポジトリは登録・ユーザー設定変更・コマンドのpushを自動実行しない。
- 今回このリポジトリからの確認はスクリプトへの疑似入力のみ。Claude Code経由の実行記録は元記事の環境と条件を参照する。
- 単純な部分一致の見本。`git -C . push` は止まらず、`echo "git push"` は止まる。空/壊れたJSONは通す。すべての危険な操作を防ぐ保証は無い。
- Anthropic公式ではない。権限のdeny/askとも組み合わせ、練習用リポジトリで確認してから使う。

## ライセンス

このリポジトリのコードと文書はMIT。元記事全体や別売り教材の再配布許可を意味しない。
