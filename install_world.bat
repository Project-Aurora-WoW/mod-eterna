@echo off
chcp 65001 >nul
REM =====================================================================
REM  Хроники Этерны — установка контента в базу мира AzerothCore
REM  Использование:  install_world.bat [имя_базы]
REM  По умолчанию база: acore_world
REM =====================================================================

setlocal
set MYSQL="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set DB=%~1
if "%DB%"=="" set DB=acore_world

echo.
echo  === Хроники Этерны: установка в базу %DB% ===
echo  MySQL: %MYSQL%
echo.

for %%F in (01_creature_template 02_item_template 03_quest_template 04_spawns 05_factions 06_areatrigger 07_creature_text 08_creature_spells) do (
    echo  --^> sql\world\%%F.sql
    %MYSQL% -uroot -proot --default-character-set=utf8mb4 --force %DB% < "sql\world\%%F.sql"
    if errorlevel 1 echo     ^(ошибки выше — см. лог^)
)

echo.
echo  === Проверка ===
%MYSQL% -uroot -proot -N --default-character-set=utf8mb4 %DB% -e "SELECT 'NPC',COUNT(*) FROM creature_template WHERE entry BETWEEN 910000 AND 919999 UNION ALL SELECT 'Спавны',COUNT(*) FROM creature WHERE guid BETWEEN 910000 AND 910099 UNION ALL SELECT 'Предметы',COUNT(*) FROM item_template WHERE entry BETWEEN 910100 AND 910199 UNION ALL SELECT 'Квесты',COUNT(*) FROM quest_template WHERE ID BETWEEN 915000 AND 915099 UNION ALL SELECT 'Реплики',COUNT(*) FROM creature_text WHERE CreatureID BETWEEN 910000 AND 919999;"

echo.
echo  Готово. Не забудьте скопировать lua_scripts\eterna в папку lua_scripts сервера.
pause
