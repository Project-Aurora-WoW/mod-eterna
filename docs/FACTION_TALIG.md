# Своя фракция «Талиг» (ID 5010)

Серверная часть уже готова и применена: `sql/world/20_faction_talig.sql`.
Осталось пропатчить клиент, иначе он не знает ID 5010 и рисует NPC
по своему `FactionTemplate.dbc` (обычно — нейтрально, но без вкладки).

---

## Что уже сделано на сервере

| Объект | Значение |
|---|---|
| `factiontemplate_dbc` | запись 5010 (копия шаблона 35, `Faction` = 5010) |
| NPC с фракцией 5010 | 11 (лагерь Талига) |
| Квесты с наградой 5010 | 16 |
| `creature_onkill_reputation` | 11 записей, репутация за Дриксен/Гайифу |

Проверено запросом:

```sql
SELECT ID, Faction, FactionGroup, FriendGroup, EnemyGroup
FROM factiontemplate_dbc WHERE ID = 5010;   -- 5010 | 5010 | 0 | 1 | 0
```

---

## Почему клиент без патча не покажет Талиг

Клиент 3.3.5a хранит фракции в двух DBC:

1. **`Faction.dbc`** — имя, описание, группа репутации (`ReputationListID`).
   Без записи 5010 вкладка «Талиг» не появится.
2. **`FactionTemplate.dbc`** — кто друг и кто враг. Без записи 5010
   клиент не отрисует цвет имени NPC.

Порядок: сначала `Faction.dbc`, потом `FactionTemplate.dbc`.

---

## Шаг 1. Экспорт обоих DBC

**WDBX.Editor** (`C:\Users\Orel\Downloads\WDBX.Editor`):

1. `File → Open` → `E:\wow\World of Warcraft 3.3.5a\Data\enUS\locale-enUS.MPQ`
   (дальше можно повторять для `ruRU`).
2. `DBFilesClient\Faction.dbc` → `Export DBC…` → `client\Faction.dbc`.
3. Так же `DBFilesClient\FactionTemplate.dbc` → `client\FactionTemplate.dbc`.

> `FactionTemplate.dbc` лежит в `Data\common-2.MPQ` (общий для локалей).
> Если в `locale-*.MPQ` его нет — откройте `common-2.MPQ`.

## Шаг 2. Faction.dbc — добавляем 5010

Экспортируйте в CSV: `Export → CSV`, откройте в таблице (или через Python).

Нужные поля строки (структура 3.3.5a):

| Поле | Значение |
|---|---|
| `ID` | **5010** |
| `ReputationIndex` | `0` |
| `ReputationRaceMask_1..4` | скопировать у фракции **35** (Friendly) |
| `ReputationClassMask_1..4` | скопировать у 35 |
| `ReputationBase_1..4` | `0,0,0,0` (нейтрально на старте) |
| `ReputationFlags_1..4` | скопировать у 35 |
| `ParentFactionID` | `0` |
| `Name_Lang_enUS` | `Talig` |
| `Name_Lang_ruRU` | `Талиг` |
| `Description_Lang_enUS` | `House Ollars. The leopard walks on stone.` |
| `Description_Lang_ruRU` | `Дом Олларов. Леопард идёт по камню.` |
| `Name_Lang_Mask`, `Description_Lang_Mask` | скопировать у строки 35 |

Проще всего: скопируйте **всю строку 35**, вставьте в конец и поправьте
`ID`, `Name_*`, `Description_*`.

## Шаг 3. FactionTemplate.dbc — добавляем 5010

Скопируйте строку **35** (`Friendly` — `FactionGroup=0`, `FriendGroup=1`,
`EnemyGroup=0`), вставьте и поправьте:

| Поле | Значение |
|---|---|
| `ID` | `5010` |
| `Faction` | `5010` |
| остальные поля (Flags, FriendGroup, EnemyGroup, Enemies_*, Friend_*) | **не менять** — скопированы у 35 |

> Если поменять группы, Талиг станет враждебным Альянсу или Орде и квесты
> перестанут браться с одной из сторон. Это главная ошибка при патче.

## Шаг 4. Сборка MPQ

**Ladik's MPQ Editor** (`...\Russian\x64\MPQEditor.exe`):

1. Откройте `E:\wow\World of Warcraft 3.3.5a\Data\patch-4.MPQ`
   (создайте, если нет: `Файл → Создать новый архив`, MPQ v3).
2. Внутри архива создайте папку `DBFilesClient\`.
3. Поместите **оба** файла туда:
   - `DBFilesClient\Faction.dbc`
   - `DBFilesClient\FactionTemplate.dbc`
4. Сохраните.

Для ruRU повторите с `Data\ruRU\patch-4.MPQ` — если клиент читает
`Faction.dbc` из локали. Проверка ниже покажет, достаточно ли одного.

## Шаг 5. Очистка кэша и проверка

1. Удалите `E:\wow\World of Warcraft 3.3.5a\Cache\WDB\`.
2. В `worldserver.conf` убедитесь: `DBC.EnforceItemAttributes = 1`
   не мешает — для фракций это неважно.
3. Запустите сервер и клиент.
4. В чате: `.go creature 910000` — Фернандо должен быть **зелёным**.
5. Откройте вкладку «Репутация» — там должна быть строка **Талиг**.
6. `.go creature 910020` — Солдат Дриксена **красный**.

Если Талиг не появился:

| Симптом | Причина |
|---|---|
| NPC нейтральные, вкладки нет | `Faction.dbc` не подхвачен — проверьте путь `DBFilesClient\` |
| NPC враждебные | в `FactionTemplate.dbc` испорчены `FriendGroup/EnemyGroup` |
| Пустое имя фракции | не заполнили `Name_Lang_ruRU`/`enUS` или `Mask` |
| Клиент падает | неверный порядок колонок в CSV — сверьте с эталонной строкой |

---

## Откат

Если что-то сломалось, верните фракцию 35:

```sql
SOURCE sql/world/00_factions_real.sql;
UPDATE quest_template SET RewardFactionID1=72 WHERE ID BETWEEN 915000 AND 915004;
```

и уберите `patch-4.MPQ`.

---

## Чтобы мод работал БЕЗ патча

По умолчанию мод уже стоит на фракции **35** (нейтральная) — это состояние
рабочее. `20_faction_talig.sql` применяйте только когда клиент пропатчен,
иначе NPC могут отображаться неверно.
