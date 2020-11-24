# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node

func _init():
    randomize()

func _ready():
    print("""Copyright (C) 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

Creative Commons (via <https://creativecommons.org/compatiblelicenses>)
is designated as a proxy that can decide which future GPL versions can be used
for Pit's End.
See section 14 of the License for more information.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

Assets for this program are licensed under
CC-BY-SA 4.0 <https://creativecommons.org/licenses/by-sa/4.0/legalcode>.

Code for this program is distributed under the GNU General Public License,
version 3 or later <https://gnu.org/licenses/gpl.html>.

Source code can be found at <https://github.com/nfitzen/benbonk-gamejam-2>.

The program icon is licensed separately:

Godot Logo (C) Andrea Calabró
Distributed under the terms of the Creative Commons Attribution License
version 3.0 (CC-BY 3.0) <https://creativecommons.org/licenses/by/3.0/legalcode>.
""")
