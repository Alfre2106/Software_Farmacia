 # ==========================================
    # ✅ PUERTO DINÁMICO PARA RENDER
    # ==========================================
    port = int(os.getenv('PORT', 5000))
    debug_mode = os.getenv('ENVIRONMENT', 'development') == 'development'
    
    print("\n" + "="*70)
    print("🏥 SISTEMA DE FARMACIA - Backend Iniciado")
    print("="*70)
    print(f"✅ Servidor corriendo en puerto: {port}")
    print(f"✅ Modo debug: {debug_mode}")
    print(f"✅ Entorno: {os.getenv('ENVIRONMENT', 'development')}")
    print(f"✅ Base de datos: {os.getenv('DB_HOST', 'localhost')}")
    print("✅ Rutas de reportes ACTIVAS:")
    print("   📊 /api/reportes/ventas-horario")
    print("   📊 /api/reportes/productos-vendidos")
    print("   📊 /api/reportes/ventas-diarias")
    print("   📊 /api/reportes/resumen-general")
    print("="*70 + "\n")
