contents ← •FLines "./input.txt"
Split ← ((⊢-˜¬×·+`»⊸<)∘∊˜⊔⊢)

ParseInt ← (10⊸×⊸+˜´∘⌽-⟜'0')

ls ← ParseInt¨¨ ⟨""⟩ Split contents

result1 ← ⌈´+´¨ls

result2 ← +´3↑∨+´¨ls
