# ExampleGame

Un videojuego 2D en desarrollo creado con Godot Engine 4, enfocado en mecánicas de combate, movimiento fluido y una arquitectura de código limpia basada en Programación Orientada a Objetos (POO).

Este proyecto sirve tanto como juego jugable como base sólida para futuros niveles, enemigos y sistemas avanzados.

## Características principales

- **Jugador con mecánicas completas**
  - Movimiento lateral
  - Salto
  - Roll / evasión
  - Knockback real
  - Sistema de vida y muerte

- **Enemigos con IA modular**
  - Patrullaje
  - Detección de jugador
  - Persecución
  - Ataque con ventana de daño real (hit window)
  - Comportamiento correcto cuando el jugador muere

- **Arquitectura limpia**
  - `BaseEntity` para lógica compartida
  - `Enemy` como clase base
  - Enemigos específicos (ej. Slime) heredan comportamiento
  - Fácil de extender y mantener

- **Cámara inteligente**
  - Límites definidos por `CameraBounds`
  - Reutilizable entre niveles
  - Editable desde el editor

- **Audio**
  - Música de fondo
  - Preparado para efectos de sonido (golpes, ataques, etc.)

## Tecnologías usadas

- **Motor:** Godot Engine 4.x
- **Lenguaje:** GDScript
- **Control de versiones:** Git + GitHub
- **Audio:** .ogg (formato recomendado por Godot)

## Estructura del proyecto

```
ExampleGame/
├── scenes/
│   ├── player/
│   ├── enemies/
│   │   ├── enemy.gd
│   │   └── slime_enemy.gd
│   ├── levels/
│   └── ui/
├── scripts/
│   ├── base_entity.gd
│   └── camera_bounds.gd
├── assets/
│   ├── sprites/
│   ├── audio/
│   └── tilesets/
├── README.md
└── project.godot
```

## Cómo ejecutar el proyecto

1. Clona el repositorio:
   ```bash
   git clone https://github.com/SVTYM/ExampleGame.git
   ```

2. Abre Godot Engine 4.

3. Selecciona la carpeta del proyecto.

4. Ejecuta la escena principal (F5).

## Controles actuales

| Acción              | Tecla          |
|---------------------|----------------|
| Mover izquierda    | ← / A         |
| Mover derecha      | → / D         |
| Saltar             | Space         |
| Rodar (Roll)       | Shift         |
| Ataque enemigo     | Automático    |

(Puede variar según el Input Map del proyecto)

## Estado del proyecto

En desarrollo activo.

Próximas mejoras:

- Más enemigos
- Menú principal mejorado
- Sonidos de impacto
- UI de vida
- Más niveles
- Guardado de progreso

## Contribuciones

Este proyecto está abierto a mejoras y aprendizaje.

Pasos para contribuir:

1. Fork del repositorio.
2. Crear una rama (feature/nueva-feature).
3. Commit de cambios.
4. Pull Request.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Eres libre de usarlo, modificarlo y aprender de él.

## Autor

Desarrollado por Victor Adonahí Fuentes Vallejo.  
GitHub: https://github.com/SVTYM

"Código limpio, mecánicas claras y bases sólidas hacen un buen juego."

