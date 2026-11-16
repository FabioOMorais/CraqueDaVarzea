# Craque da Várzea

Jogo de plataforma 2D feito no Godot 4.7 (renderer *Compatibility*).
Do campinho do bairro até a final do campeonato: atravesse a várzea, chegue ao estádio,
derrote o chefão e levante a taça.

## Como abrir
Godot 4.7 → **Importar** → escolher o `project.godot` → **F5** (começa no menu).

## Controles
| Ação | Tecla |
|---|---|
| Andar | A / D ou setas |
| Pular | W, Espaço ou seta pra cima |
| Carrinho (curto alcance) | J |
| Chutar a bola (longo alcance) | K |
| Cabeçada (curto alcance, também no ar, rebate cartões) | L |
| Pausar | Esc ou P |

## O que tem no jogo
- **Telas:** início, como jogar, configurações (volume de música e de efeitos separados, tela cheia), pausa, fim de jogo e vitória.
- **Fase 1 (várzea):** árbitros, goleiros, plataformas, figurinhas, garrafinha d'água e a porta do vestiário no final.
- **Fase 2 (estádio):** mais inimigos e a arena do chefão. Quando o jogador entra, a porta fecha e a música muda.
- **Jogador:** andar, pular, carrinho, chute (a bola tem gravidade e quica) e cabeçada. Ao levar dano, é empurrado e fica 1,2 s invencível, piscando.
- **Árbitro** (3 de vida): olha pro jogador e, quando ele chega perto, apita e joga cartão. A cada 3 cartões, um é **vermelho** e tira 2 vidas. Uma cabeçada **rebate o cartão** contra os inimigos.
- **Goleiro** (3 de vida): patrulha a área dele, corre atrás do jogador e dá um **bote** (mergulho).
- **Chefão: o Cartão Vermelho** (20 de vida, barra no HUD): bate no chão soltando **ondas** que é preciso pular; com metade da vida fica **nervoso**. Derrotado, os **portões do estádio** se abrem.
- **VAR** (4 de vida): robô-monitor que persegue o jogador dando saltos.
- **Munição:** começa com 6 bolas; cada chute gasta 1; pacotes de bola dão +3 (máx. 10).
- **Plataformas móveis** em cada fase.
- **Itens:** figurinha (+10 pontos) e garrafinha d'água (+1 vida, até no máximo 5).
- **Pontuação:** árbitro 100, goleiro 150, chefão 1000, taça 500, garrafinha 50.

## Estrutura
```
assets/    imagens (sprite sheets em grade, itens, fundos, tema dos botões)
cenas/     uma cena .tscn para cada coisa (jogador, inimigos, itens, fases, telas)
scripts/   um script para cada cena + global.gd (autoload)
sons/      efeitos sonoros (.wav)
musicas/   músicas de menu, fase, chefão, vitória e fim de jogo (.ogg)
```

## Como as partes conversam
- `global.gd` é um **autoload**: guarda vidas, pontos, figurinhas e a fase atual, e troca de fase.
- Tudo que pode levar dano tem a função `levar_dano(direcao)`. A bola, o carrinho, a cabeçada e o cartão rebatido só chamam essa função.
- O jogador tem `receber_dano(quantidade, posicao_x)`. Cartões, goleiro, chefão e ondas chamam essa função.
- As animações chamam funções nos quadros certos (method track): `chutar_bola`, `jogar_cartao`, `bater_no_chao`.
- As hitboxes do carrinho e da cabeçada são `Area2D` que a própria animação liga e desliga.
- A música repete porque o sinal `finished` do `AudioStreamPlayer` está ligado no `play` dele mesmo.

## Camadas de colisão
1 mundo · 2 jogador · 3 inimigos · 4 bola · 5 itens · 6 projéteis (cartões)
