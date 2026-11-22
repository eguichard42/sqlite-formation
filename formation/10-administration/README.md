# Maintenance et récupération


L’API de sauvegarde en ligne utilisée par `.backup` produit un instantané cohérent, y compris en WAL. `.restore` recharge cet instantané. Évitez de copier uniquement le fichier principal pendant l’activité. `integrity_check` inspecte les structures et `foreign_key_check` inspecte les références. `ANALYZE` construit des statistiques pour l’optimiseur. `VACUUM` reconstruit le fichier hors transaction explicite et requiert de l’espace libre. Il s’apparente à une reconstruction globale et peut changer les rowid sans alias déclaré.

Sur la base de formation, employez les commandes de [maintenance du projet](../../README.md#maintenance). Pour le cinquième exercice, utilisez le CLI sur une copie jetable et choisissez un fichier de sauvegarde distinct.


[Exemples exécutables](exemples.sql) · [Corrigés commentés](corriges.sql)

## Exercices

1. Inspecter la taille et le nombre de pages.
2. Vérifier l’intégrité structurelle et les références.
3. Calculer et consulter les statistiques des index de commandes.
4. Comparer les pages libres avant et après VACUUM.
5. Sauvegarder la copie, modifier un prix puis restaurer et contrôler le prix.
