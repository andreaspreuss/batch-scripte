## Batch Script zum Entfernen des "System Volume Information" Ordners von Wechseldatenträgern ##

Windows schreibt auf USB Wechseldatenträger den versteckten Ordner **System Volume Information**

Oft können einige externe Geräte diesen versteckten Systemordner nicht verarbeiten und
wollen den Datenträger stattdessen neu formatieren.
Daher ist es dann nicht mehr möglich, effektiv Daten auszutauschen.

Dies betrifft teilweise Kameras, smarthome Geräte und medizinische Apparate.

Mit dieser Batch Datei habe ich mal versucht eine tempöräre Lösung zu finden, den
ungeliebten Ordner jeweils zu entfernen.
