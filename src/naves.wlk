class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method cargarCombustible(cuanto) {
		combustible += cuanto
	}
	
	method descargarCombustible(cuanto) {
		combustible = 0.max(combustible - cuanto)
	}
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto.abs()).min(100000)
	}
	method desacelerar(cuanto) { 
		velocidad =  0.max(velocidad - cuanto.abs())}
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol() { 
		direccion = 10.min(direccion++)
	}
	
	method alejarseUnPocoDelSol() {
		direccion = -10.max(direccion--)
	}
	
	method prepararViaje() {
		self.prepararViajeCondicionComun()
		self.prepararViajeCondicionParticular()
	}
	
	method prepararViajeCondicionComun() {
		self.cargarCombustible(30000)
		self.acelerar(5000)		
	}
	
	method prepararViajeCondicionParticular() //método abstracto
	
	method estaTranquila() {
		return combustible >= 4000 && 
		velocidad <= 12000
	}
	
	method escapar() //método abstracto
	method avisar() //método abstracto
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method estaDeRelajo() {
		return self.estaTranquila() && self.tienePocaActividad()
	}
	
	method tienePocaActividad() //método abstracto

}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza = "rojo"
	var cambioColor = 0
	method mostrarColorBaliza() = colorBaliza
	method cambiarColorDeBaliza(colorNuevo) {
		colorBaliza = colorNuevo
		cambioColor++
	}

	override method prepararViajeCondicionParticular() {
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() {
		return super() && colorBaliza != "rojo"
	}
	
	override method escapar() {
		self.irHaciaElSol()
	}
	
	override method avisar() {
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method tienePocaActividad() {
		return cambioColor == 0
	}
}

class NaveDePasajeros inherits NaveEspacial {
	const property cantidadPasajeros 
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var racionesDeComidaServidas = 0
	
	method cargarComida(cuanto) {racionesDeComida += cuanto}
	method descargarComida(cuanto) {
		racionesDeComida = 0.max(racionesDeComida-cuanto)
		racionesDeComidaServidas += cuanto
	}
	method cargarBebida(cuanto) {racionesDeBebida += cuanto}
	method descargarBebida(cuanto) {
		racionesDeBebida = 0.max(racionesDeBebida-cuanto)
	}
	method racionesDeComida() = racionesDeComida
	method racionesDeBebida() = racionesDeBebida
	
	override method prepararViajeCondicionParticular() {
		self.cargarComida(4*cantidadPasajeros)
		self.cargarBebida(6*cantidadPasajeros)
		self.acercarseUnPocoAlSol()
	}	
	
	override method escapar() {
		self.acelerar(velocidad*2)
	}
	
	override method avisar() {
		self.descargarComida(cantidadPasajeros)
		self.descargarBebida(cantidadPasajeros*2)
	}
	
	override method tienePocaActividad() {
		return racionesDeComidaServidas < 50
	}
	
}

class NaveDeCombate inherits NaveEspacial {
	var estaInvisible = false
	var misilesDesplegados = false
	const property mensajesEmitidos = []
	
	method estaInvisible() = estaInvisible
	method ponerseVisible() {estaInvisible = false}
	method ponerseInvisible() {estaInvisible = true}
	method misilesDesplegados() = misilesDesplegados
	method replegarMisiles() {misilesDesplegados = false}
	method desplegarMisiles() {misilesDesplegados = true}
	
	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method primerMensajeEmitido() { 
		if(mensajesEmitidos.isEmpty()) self.error("no hay mensajes")
		return mensajesEmitidos.first()
	}

	method ultimoMensajeEmitido() { 
		if(mensajesEmitidos.isEmpty()) self.error("no hay mensajes")
		return mensajesEmitidos.last()
	}
	
	method esEscueta() {
		return mensajesEmitidos.all({m=>m.size()<=30})
	}
	
	method esEscuetaConAny() {
		return !mensajesEmitidos.any({m=>m.size()>30})
	}
	
	method emitioMensaje(mensaje) {
		return mensajesEmitidos.contains(mensaje)
	}
	
	override method prepararViajeCondicionParticular() {
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en mision")
		self.acelerar(15000)
	}
	
	override method estaTranquila() {
		return super() && !self.misilesDesplegados()
	}	
	
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}

	override method tienePocaActividad() {
		return self.esEscueta()
	}

}

class NaveHospital inherits NaveDePasajeros {
	var property quirofanosPreparados = false
	override method estaTranquila() {
		return super() && !quirofanosPreparados
	}
	
	override method recibirAmenaza() {
		super()
		self.quirofanosPreparados(true)
	}
}

class NaveSigilosa inherits NaveDeCombate {
	override method estaTranquila() {
		return super() && !self.estaInvisible()
	}
	override method escapar() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}

