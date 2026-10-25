# reference 4: independent reference of the 31 function rows

### Owners

|Owner|Caminho|
|---|---|
|O01|`audio/engine.asm`|
|O02|`engine/account/registration_verify.asm`|
|O03|`engine/account/result_page.asm`|
|O04|`engine/account/settings_page.asm`|
|O05|`engine/address_book/address_editor.asm`|
|O06|`engine/address_book/name_editor.asm`|
|O07|`engine/browser/page_list.asm`|
|O08|`engine/comm/comm_scene.asm`|
|O09|`engine/comm/time_hooks.asm`|
|O10|`engine/html/link_tables.asm`|
|O11|`engine/html/parser.asm`|
|O12|`engine/keyboard/keyboard.asm`|
|O13|`engine/mail/address_editor.asm`|
|O14|`engine/mail/body_editor.asm`|
|O15|`engine/mail/mail_title_entry.asm`|
|O16|`engine/mail/received_mail_grid.asm`|
|O17|`engine/mail_server/delete_flows.asm`|
|O18|`engine/mail_server/delete_hidden.asm`|
|O19|`engine/mail_server/delete_messages.asm`|
|O20|`engine/mail_server/tidy.asm`|
|O21|`engine/main/navigation.asm`|
|O22|`engine/profile/profile_editor.asm`|
|O23|`engine/settings/continue_prompt.asm`|
|O24|`engine/sram/integrity_check.asm`|
|O25|`engine/text/charset_convert.asm`|
|O26|`engine/unreferenced/page_list_prototype.asm`|
|O27|`lib/mobile/mail.asm`|

### 72 cores selecionados

|ID|Owner:linha|Banco:[início,fim)|B/starts|Efeito e frame|Limites específicos|
|---:|---|---|---:|---|---|
|1|O01:2442|`04:[4D53,4D54)`|1/1|DEC HL; cai no driver|sem stack local; cauda/pointers/IO condicionados|
|2|O02:398|`68:[7312,7313)`|1/1|RET;PC=word[S],SP+2|AFBCDEHL/seletores locais intactos|
|3|O03:103|`68:[7740,7741)`|1/1|RET;PC=word[S],SP+2|separado dos JR vizinhos|
|4|O04:188|`68:[48C6,48C8)`|2/2|XOR A/RET;A0,F80,SP+2|não herda ação do vizinho|
|5|O05:342|`2F:[6F44,6F4D)`|9/6|B7/C0B→RET;senão cauda|goal41/C40 difere de21; buffers/helper|
|6|O05:1034|`2F:[73A6,73AA)`|4/3|INC/DEC C;tailsPOPBC/RET|BC=word[S],PC=word[S+2],SP+4|
|7|O06:44|`2F:[582D,5832)`|5/3|POPAF/CP1/JR5854 ou5832|SP+2;CP substitui F; loop pode não retornar|
|8|O06:169|`2F:[590B,5914)`|9/6|Guard B7/C0B;cauda goal08/C08|mesmo core de5; consumidor diferente|
|9|O06:605|`2F:[5C30,5C34)`|4/3|INC/DEC C;tailsPOPBC/RET|SP+4;BC externo, não argumento preservado|
|10|O06:732|`2F:[5CC5,5CD2)`|13/7|WRAM1;CP0 substituiCP0D|caudas consomem2words;PC=word[S+4],SP+6|
|11|O06:1134|`2F:[5F28,5F30)`|8/5|RAMG/FFF5=0;POPBC/RET|A0/F80;frame externoBC;SP+4|
|12|O06:1256|`2F:[6007,600F)`|8/5|RAMG/FFF5=0;POPBC/RET|idêntico11;stack legível sem SRAM|
|13|O06:1382|`2F:[60B8,60C0)`|8/5|RAMG/FFF5=0;POPBC/RET|idêntico11;sem restaurar enable anterior|
|14|O07:340|`24:[42AF,42B0)`|1/1|RET;SP+2|não executa cópias de42B0|
|15|O08:971|`70:[4740,477F)`|63/32|SRAM1:A9ED.bit7→B/A0/1|2AF salvos/restaurados;Fentrada;FFF2 amostra|
|16|O09:26|`7F:[620C,6218)`|12/7|C26B<1E→A0;senãoAFF|F80 ouCP1E;SP+2;sem unidade temporal|
|17|O10:176|`74:[5B3E,5B3F)`|1/1|POPBC,POPDE,scan com folding|SP+6−2k;word noRET pode ter sido reescrita|
|18|O11:367|`74:[43C3,43C4)`|1/1|POPHL;cauda escreve header/scroll|SP+4;mapper porH e progressos condicionados|
|19|O12:296|`55:[5DF5,5E02)`|13/5|LookupC2AB;OR;JP5E5A/5F29|sem RET;índice não limitado;tails próprias|
|20|O12:908|`55:[6184,6190)`|12/6|Dois storesFF emC2BD/C2BE|6B cada;RETs separados;F intacto,SP+2|
|21|O13:354|`2D:[681E,6827)`|9/6|Guard B7/C0B;cauda goal40/C40|core igual5/8;não copiar goal41 de5|
|22|O13:1072|`2D:[6CCD,6CD1)`|4/3|INC/DEC C;tailsPOPBC/RET|SP+4;carry original,DEC regeZNH|
|23|O13:1517|`2D:[6F7A,6F7B)`|1/1|RET;SP+2|JP anterior contorna;entrada não inferida|
|24|O14:575|`2D:[4B2D,4CA5)`|376/141|Setup+13far+8drawrows|POPextra;PC=word[S+2],SP+4;helpers/IRQ|
|25|O14:955|`2D:[4E04,4E06)`|2/2|POPBC/RET|PC=word[S+2],SP+4;AFDEHL intactos|
|26|O14:1094|`2D:[4EAE,4EB2)`|4/3|INC/DEC C;tailsPOPBC/RET|C original controla;retorno substituiBC|
|27|O14:2180|`2D:[54D2,54DA)`|8/5|RAMG/FFF5=0;POPBC/RET|A0/F80,SP+4;JR só prova bypass|
|28|O14:2292|`2D:[55A1,55A9)`|8/5|Mesmo epílogo8B de27|SP+4;qualificar “nenhum caminho”|
|29|O14:2413|`2D:[5642,564A)`|8/5|Mesmo epílogo8B de27|SP+4;qualificar “nenhum caminho”|
|30|O14:2573|`2D:[574E,574F)`|1/1|RET;SP+2|separado doJP precedente|
|31|O14:2614|`2D:[5799,579A)`|1/1|RET;SP+2|não entra na cauda seguinte|
|32|O14:2802|`2D:[58D6,58D9)`|3/1|JP5691|sem mudança local de regs/F/SP;estado do loop|
|33|O14:2927|`2D:[59AD,59B1)`|4/2|JP56C6;RET59B0 alternativo|JP não cai noRET;destino pode não retornar|
|34|O14:3048|`2D:[5A60,5A6F)`|15/7|PUSHBC/farHide;SCY=C0D3=0|POPBC/RET balanceado secallees retornam|
|35|O14:3068|`2D:[5A78,5A7B)`|3/2|RET5A78;JR5A79 autorreferente|entradas alternativas;loop sem deadline|
|36|O14:3098|`2D:[5A97,5A98)`|1/1|RET;SP+2|separado doRET precedente|
|37|O15:629|`2C:[4463,4467)`|4/3|INC/DEC C;mesmo core26|tails SP+4;dead não provado universalmente|
|38|O15:732|`2C:[44DB,44DC)`|1/1|RETNZ;Z1 cai44DC|Z0 SP+2;predecessorRET44DA,nãoJP/JR|
|39|O15:810|`2C:[456D,457A)`|13/7|WRAM1;CP0 substituiCP0D|NUL→459C;senão457A;sem stack no core|
|40|O15:1177|`2C:[4760,4768)`|8/5|RAMG/FFF5=0;POPBC/RET|mesmos8B;PC=word[S+2],SP+4|
|41|O15:1309|`2C:[483F,4847)`|8/5|Mesmo epílogo8B|entryHYP;busca histórica não écaller|
|42|O15:1437|`2C:[48F0,48F8)`|8/5|Mesmo epílogo8B|entryHYP;stack legível apósRAMG0|
|43|O16:640|`2B:[5806,5807)`|1/1|RET5806;SP+2|separado doRET5805|
|44|O17:96|`23:[4AA4,4AA6)`|2/1|JR4B1A (1874)|JP anterior contorna;entrada/frame abertos|
|45|O17:276|`23:[4BE5,4BE7)`|2/1|JR4C5D (1876)|template44,displacement diferente|
|46|O17:956|`23:[5028,503F)`|23/18|WRAM1;incwordD629;fall503F|HL/SP/F preservados;BC D62A;tail decrementa|
|47|O17:1515|`23:[540D,5424)`|23/18|Twin23B de46;fall5424|tail36B igual;sem copiar caller/purpose|
|48|O18:744|`22:[47DD,47DE)`|1/1|RET47DD;SP+2|bypass sequencialJP47DA;sem função nova|
|49|O18:1286|`22:[4BB5,4BB7)`|2/1|JR4C2B (1874)|JP anterior contorna;não prova inacessível|
|50|O18:1475|`22:[4D00,4D02)`|2/1|JR4D76 (1874)|mesmos2B49,destino distinto|
|51|O18:1656|`22:[4E41,4E43)`|2/1|JR4EB9 (1876)|displacement diferente;tail/frame separados|
|52|O19:210|`23:[6F22,6F3C)`|26/15|PUSH4;WRAM7/1;renderizador tempo|POPs compartilhados;SP+2 normal;IRQ/bancos|
|53|O19:256|`23:[6F60,6F6F)`|15/7|Minute+3C;CP64;tail render|sem saves;consome8B;PC=word[S+8],SP+10|
|54|O20:1211|`2E:[488A,488E)`|4/4|PUSH4→cauda tidy|normalSP+2;alternativa POP7→SP+8,PCword[S+6]|
|55|O21:299|`7C:[7D8B,7D8D)`|2/1|LD A0→7D8D|F/BCDEHL/SP intactos;JP7D88 contorna|
|56|O21:354|`7C:[7DFC,7DFF)`|3/1|JP7D57|sem efeito local de stack;loop não garanteRET|
|57|O22:330|`2A:[56CB,56EC)`|33/11|CALL6257+8CALL577F;JP54FD|CALL62C5 posterior éalternativo;callees|
|58|O22:434|`2A:[5781,578A)`|9/6|Guard B7/C9→RET;senão578A|A9/FC0 noRET;core difereC9 dosguardsC0B|
|59|O22:1161|`2A:[5C7D,5C81)`|4/3|INC/DEC C;tailsPOPBC/RET|mesmos4B;BC externo,PCword[S+2],SP+4|
|60|O22:1329|`2A:[5D7E,5D8B)`|13/7|WRAM1;CP0 substituiCP0D|NUL→5DAD;tails precisam2words externas|
|61|O22:1680|`2A:[5F69,5F71)`|8/5|RAMG/FFF5=0;POPBC/RET|mesmos8B;SP+4;semrestaurar enable|
|62|O22:1797|`2A:[6048,6050)`|8/5|Mesmo epílogo8B|SP+4;stack fora deSRAM desabilitada|
|63|O22:1915|`2A:[60F9,6101)`|8/5|Mesmo epílogo8B|bancoSRAM vigente permanece|
|64|O22:2079|`2A:[6222,6223)`|1/1|RET;SP+2|JP anterior contorna;sem entry nova|
|65|O22:2108|`2A:[6253,6257)`|4/2|JP617B;RET6256 alternativo|sem aresta sequencialJP→RET|
|66|O23:106|`67:[580C,5821)`|21/11|SFX002E solicitado;C27C=0|A0/F80;SVBK←shadow amostrado;IRQ/gate|
|67|O24:358|`22:[50CF,50FC)`|45/29|Duas wrapperschecksum/clear|primeiraAFBCDEHL;segundaAFF/A1;SRAM1 off|
|68|O25:536|`7E:[7DDF,7DE5)`|6/3|A2;FFB1=2;JR7D75|estado persiste;semRET local|
|69|O26:2780|`7F:[61E8,61FC)`|20/9|WRAM7;zeraC2D4..C2D7|A0/F80;SP+2;WRAM7 não restaurada|
|70|O27:1264|`0F:[47A5,47BB)`|22/10|Banco←D003;scan4A7E;tails47BB/CF|DE/union/mapping/progresso condicionados|
|71|O27:2202|`0F:[4C59,4C62)`|9/5|SaveBC;NextSramPage;restore/RET|D!=BF:INCD regeZNH,CdoCP;fronteiraBF troca banco|
|72|O27:2369|`0F:[4D35,4D37)`|2/1|B82→POPHL/A1/JP4260|AF externo;PCword[S+4],SP+6;Afinal≠1 geral|

### Storage e alcance deste fechamento

Os32 headers UNCLASSIFIED/storage pertencem a um escopo separado desses72 comentários. A auditoria finita dos32 emissores db conferiu122 bytes originais. O header54:4CAD foi corrigido para texto CONFIRMED:81 63 00 é elipse Shift-JIS maisNUL, consumida por Text_TruncateSjis/CopyString ou CopyBytes. O header24:4BCC agora descreve1B em vez de10. Os outros31 intervalos continuam storage UNCLASSIFIED; não foi demonstrada uma função viva com mecanismo local ausente nesses bytes. Decode legal e contrato hipotético não bastam para converterdb a código; ver classify_g6.md, seção7. As listas145/72/32 se sobrepõem e não se somam como funções. Outros intervalos sem comentário/callers computados/limites de entrada não foram cobertos universalmente.

### 2026-10-15: positive classification of the 26:5344 fragment

The inactive `Function_26_5343` alias had no active assembly reference and was removed; `Stub_Nop_26_5343` remains the known single-RET no-op.

The call at `26:58E0` targets that RET at `5343`, so it returns before this fragment.

Under ordinary CGB mappings, the fragment selects WRAM bank 7 at `26:535D-5363`; the loop at `26:5363-536E` addresses `$D160-$D19F`, writing `$00..$3F`.

This is `wScreenTileMap+$160`: two complete 32-byte rows, 11 and 12.

The live `MailSession_InitScreen` sequence at `26:52D8-52E6` selects VRAM bank 0 and fills `$9960-$999F` with the same 64-byte sequence.

The screen-map buffer starts at WRAM7 `$D000`, corresponding to VRAM `$9800`; both ranges therefore have offset `$160`.

- Entry `5344` pushes AF/BC/DE/HL, samples the value read from `rSVBK` into E and sets D to `$32`   (50 iterations).

`.repeatFills` is at `534D`, `.fillTileFF` at `5357` and `.fillScreenRows` at `5369`. - Each iteration issues 16 `$FF` stores to VRAM bank 1 `$9010-$901F`, then selects WRAM bank 7 and   issues 64 ascending stores `$00..$3F` to `$D160-$D19F`.

Totals are 800 VRAM store attempts and 3,200 WRAM stores   if entered and completed with stable mapping and no interfering execution.

These four register   pairs are restored before RET only if that stack remains physically bank-invariant as SVBK   changes (for example, WRAM0/HRAM).

Later evidence reclassified `28:4BA6–4BC2` as PROBABLE code; see the current [Japanese residual matrix](japanese_remaining_semantics_batch_20261024.md).

The separate already-CONFIRMED ellipsis bytes at `54:511B–511D` had a stale UNCLASSIFIED header, now corrected as text.

### 2026-10-20: descriptive label for the 26:5344 code fragment

The maintained source label is now `MailSession_WriteVram1TileAndWram7ScreenRows`. This mechanical
name describes the two observed store sequences: the fragment attempts `$FF` writes to VRAM1
`$9010-$901F`, then writes `$00-$3F` to the two screen-map rows at WRAM7 `$D160-$D19F`. “Write”
does not claim the PPU accepted the VRAM writes. The source name replaces the generic `Data_26_5344`;
the instruction bytes, addresses, local-label addresses and emitted bytes are unchanged.

No entry, caller, intended role, natural execution or hardware-accepted VRAM operation is established: the code-fragment classification remains **PROBABLE**, while entry and intended role remain **HYPOTHESIS**.

### 2026-10-23: relation to the loaded MailSession tile source

`MailSession_InitScreen` loads 64 tiles from `MailSession_Tiles_62E0` to VRAM bank 1 at `$9000` (`engine/mail/mail_session_screen.asm:254-259`; `gfx/previews/screen_ops.tsv`).

The candidate at `26:5344` writes the same sixteen values to VRAM1 `$9010-$901F`.
