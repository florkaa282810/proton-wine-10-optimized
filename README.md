# Proton Wine 10 - Extreme Optimized Edition for ARM64EC (Adreno/Mali)

Bem-vindo à versão mais otimizada do Proton Wine 10, especialmente desenvolvida para dispositivos ARM64EC com GPUs Adreno e Mali. Esta edição foi cuidadosamente ajustada para proporcionar a melhor experiência de jogo possível, visando 80 FPS estáveis em títulos exigentes como Euro Truck Simulator 2 (ETS2) e American Truck Simulator (ATS), mesmo nas versões mais recentes como ETS 1.60.

## Por que esta versão é diferente?

Enquanto as versões padrão do Proton são genéricas, esta compilação é um "Proton de Corrida", com otimizações cirúrgicas que exploram as características únicas da arquitetura ARM64EC e das GPUs móveis. As principais melhorias incluem:

1.  **Otimizações de GPU (Adreno/Mali):**
    *   **Vulkan Tile-Based Optimization:** Ajustes no driver Vulkan para GPUs Adreno e Mali, reduzindo o consumo de banda de memória e otimizando o pipeline de renderização para arquiteturas baseadas em tiles.
    *   **Boost de Performance:** Força o modo de performance para filas Vulkan e aumenta o buffer de comandos do WineD3D para 2MB, minimizando context switches e melhorando o throughput gráfico.

2.  **Otimizações de CPU e Sistema:**
    *   **Fast-Path de Syscalls (ARM64EC):** Redução drástica da latência na tradução de chamadas de sistema (syscalls) de x86 para ARM64, utilizando instruções de barreira de memória (`isb; dsb sy`) para acelerar a comunicação entre o jogo e o sistema operacional.
    *   **Scheduler Gaming Boost:** Priorização agressiva de threads de jogo para os núcleos de performance (BIG cores) e uso da política de agendamento `SCHED_BATCH` para garantir throughput máximo da CPU.
    *   **Redução de Barreiras de Memória:** Otimizações no gerenciamento de memória virtual do ntdll para reduzir a frequência de barreiras de memória, resultando em acesso a dados mais fluido e menos micro-stutters.
    *   **L3 Cache Hints:** Inclusão de dicas de pré-busca para o cache L3, melhorando o acesso a padrões de memória críticos e reduzindo a latência.

3.  **Otimizações de I/O e Áudio:**
    *   **I/O Throughput Boost:** Aumento do tamanho do buffer de I/O para 128KB, melhorando a velocidade de leitura e escrita de dados do disco, essencial para jogos com carregamento constante de assets.
    *   **Audio Latency Reduction:** Redução do tamanho do buffer ALSA para 50ms, diminuindo a latência de áudio e proporcionando uma experiência sonora mais responsiva.

4.  **Otimizações de Compilador:**
    *   **Flags Agressivas:** Utilização de flags de compilador como `-O3 -march=native -mtune=cortex-a76 -fomit-frame-pointer -flto` para extrair a máxima performance do código compilado, adaptado especificamente para CPUs ARM de alto desempenho.

## Instalação e Uso

1.  Baixe o arquivo `.wcp` mais recente da seção [Releases](https://github.com/Florkaa282810/proton-wine-10-optimized/releases) ou dos [Artifacts](https://github.com/Florkaa282810/proton-wine-10-optimized/actions) (procure pelo build mais recente com o commit `EXTREME BOOST`).
2.  Siga as instruções específicas do seu launcher (ex: Winlator, Box64Droid) para importar e usar este Proton customizado.
3.  Aproveite a performance sem precedentes em seus jogos Windows no Android!

## Contribuições

Este projeto é um esforço contínuo para aprimorar a experiência de jogos no Android. Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests com sugestões de melhoria ou novos patches.

## Licença

Este projeto é licenciado sob a GNU LGPL, a mesma licença do Wine original. Veja o arquivo `LICENSE` para mais detalhes.

---

**Florkaa282810**
*Proton Wine 10 - Extreme Optimized Edition*
