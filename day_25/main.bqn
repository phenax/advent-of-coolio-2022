Split ← ((⊢-˜¬×·+`»⊸<)∘∊˜⊔⊢)

ParseInt ← (10⊸×⊸+˜´∘⌽-⟜'0')

FromSnafuDigit ← {
  '=': -2;
  '-': -1;
  ParseInt ⟨𝕩⟩
}

Indexed ← (↕ ∘ ≠)⊸(∾¨)

Fst ← ⊑
Snd ← { ⊑ (1 ↓ 𝕩) }

Baaaa ← { Fst 𝕩 ({ (5 ⋆ 𝕨) × 𝕩 }) Snd 𝕩 }

FromSnafu ← +´ ∘ (Baaaa¨) ∘ Indexed ∘ ⌽ ∘ (FromSnafuDigit¨)

ToSnafuDigit ← {
  ¯2: "=";
  ¯1: "-";
  •Fmt 𝕩
}

ToSnafu ← {
  0: "";
  (5|𝕩) > 2 ? (ToSnafu 1 + ⌊ 𝕩 ÷ 5) ∾ ToSnafuDigit ((5|𝕩) - 5);
  (ToSnafu ⌊ 𝕩 ÷ 5) ∾ ToSnafuDigit 5|𝕩
}

input ← •FLines "./input.txt"

result ← ToSnafu +´ FromSnafu¨ input

•Show result

