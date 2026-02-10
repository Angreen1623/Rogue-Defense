# Guia de Criação de Conteúdo: Inimigos & NPCs

Este guia explica como criar, editar e integrar novos conteúdos (Inimigos e NPCs) no Rogue-Defense usando o **Snapshot System**.

---

## 👹 Criando um Novo Inimigo

Inimigos no Rogue-Defense são definidos por **Resources** (`EnemySnapshot`). Isso permite criar variações de inimigos sem escrever novo código.

### Passo 1: Criar o Arquivo Resource
1.  No FileSystem do Godot, clique com botão direito na pasta `resources/enemies/`.
2.  Selecione **Create New...** -> **Resource**.
3.  Busque por `EnemySnapshot` (este é nosso tipo de resource customizado).
4.  Nomeie o arquivo (ex.: `OrcWarrior.tres`) e salve.

### Passo 2: Configurar Stats
Clique duas vezes no novo arquivo `.tres` para abri-lo no Inspector. Você verá as seguintes propriedades:

*   **Id**: Identificador único em string (ex.: `orc_warrior`). Usado para quests ou lógica específica de onda.
*   **Max Hp**: Pontos de vida totais.
*   **Speed**: Velocidade de movimento (pixels por segundo).
    *   *BaseEnemy padrão: ~50-100*.
*   **Damage**: Dano causado ao Player/Torre no impacto.
*   **Sprite Frame**: (Legado) Índice do frame do sprite para usar se estiver usando spritesheet.

### Passo 3: Registrando o Inimigo
*   **Carregamento Automático**: O sistema `SnapshotLoader` escaneia automaticamente `resources/enemies/` ao iniciar o jogo.
*   **Wave Manager**: Por padrão, o `WaveManager` escolherá inimigos aleatórios da lista carregada para spawnar.
    *   *Para garantir que um inimigo específico spawne*, você pode adicioná-lo manualmente à lista `Possible Enemies` na cena do Inspector do `WaveManager`.

---

## 👥 Criando/Editando NPCs

Dados de NPC são atualmente armazenados num formato legado chamado `NpcSnapshot`. Este é um arquivo único contendo um dicionário de todos os NPCs.

### Passo 1: Localizar o Arquivo
*   Vá para `data/legacy_data/npc/NpcSnapshot.gd`.
*   Nota: O arquivo `.tres` carrega este script.

### Passo 2: Editar a Fonte de Dados
Abra `NpcSnapshot.gd`. Você verá um array de dicionários:

```gdscript
var npcs := [
    {"id": 0, "name": "Yasmin", "on_guild": true, "bonus": "attack_speed"},
    {"id": 1, "name": "Patrick", "on_guild": true, "bonus": "damage"},
    ...
]
```

### Passo 3: Adicionar um Novo NPC
Simplesmente adicione (append) um novo dicionário à lista:

```gdscript
    {"id": 5, "name": "Novo Personagem", "on_guild": false}
```

### Passo 4: Usando Dados de NPC
Para acessar estes dados via código (ex.: para diálogos ou bônus):

```gdscript
# Obter todos os NPCs
var all_npcs = SnapshotLoader.get_all_npcs()

# Obter NPC específico
var yasmin = SnapshotLoader.get_npc_by_id(0)
print(yasmin.name) 
```

---

## ⚔️ Adicionando Skills/Ataques (Implementação Futura)

Atualmente, inimigos realizam um "Touch Attack" básico (dano na colisão). Para adicionar ataques customizados:

1.  **Código Necessário**: Você deve modificar `BaseEnemy.gd` ou criar uma subclasse (ex.: `ShooterEnemy.gd`).
2.  **Extensão de Recurso**:
    *   Adicione uma nova variável export no `EnemySnapshot.gd`: `@export var attack_range: float`.
    *   Atualize o script do Inimigo para ler este valor.

> **Nota**: Conforme o Sistema de Draft (Fase 3) for implementado, provavelmente criaremos um resource `SkillSnapshot` para permitir skills "plug-and-play" tanto para Jogadores quanto Inimigos.
