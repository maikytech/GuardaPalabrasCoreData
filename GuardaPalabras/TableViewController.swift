//
//  TableViewController.swift
//  GuardaPalabras
//
//  Created by Maiqui Cedeño on 5/10/17.
//  Copyright © 2017 Poseto Studio. All rights reserved.
//

import UIKit
import CoreData         //Libreria necesaria para el manejo de CoreData.

class TableViewController: UITableViewController
{
    
    //Arreglo de palabras para ingresar los datos a la tabla.
    //var palabrasTabla:[String] = ["Lunes", "Mazda", "Sega"]         //En CoreData ya no lo necesitamos.
    
    //Array de objetos del tipo NSManagedObject.
    //NSManagedObject es una clase genérica que implementa todo el comportamiento básico requerido de un objeto en CoreData.
    //No es posible utilizar instancias de subclases directas de NSObject (o cualquier otra clase que no hereda de NSManagedObject) en un contexto de objeto administrado en CoreData.
    //Un objeto tipo NSManagedObject está asociado con una descripción llamada entity (una instancia de NSEntityDescription) que proporciona metadatos sobre el objeto (incluido el nombre del entity que representa el objeto y los nombres de sus atributos y relaciones)
    var palabrasTablaConManagedObject : [NSManagedObject] = []
    
    /* Cada uno de los objetos de este arreglo es del tipo NSManagedObject y representa un objeto guardado en Core Data, 
        estos objetos se utilizan para crear, guardar, editar y eliminar datos persistentes en CoreData. */
    
    /* Los objetos de NSManagedObject (como los de este arreglo) pueden tomar diferentes formas, es decir que pueden tomar
        la forma de cualquier entidad "Entity" de tu "data model" (representado en el archivo: GuardaPalabras.xcdatamodeld)
        y se apropiará de cualquier atributo o relacion que tu definas en dicho "data model". */
    
    //Entity es la analogia de Clase, en este caso, nuestro entity será Lista, como atributo o propiedad colocaremos "palabra" del tipo String, todo esto se configura en el GuardaPalabras.xcdatamodeld.

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Se crea una referencia al delegado de la aplicación.
        //UIApplication es la clase principal de toda aplicacion de iOS.
        //Cuando la app es lanzada, se crea un objeto singleton del tipo UIApplication, accedemos a dicho objeto a traves de la propiedad shared.
        //delegate es la referencia al delegado del objeto singleton de la app.
        let appDelegateReference = UIApplication.shared.delegate as? AppDelegate
        
        //NSPersisitentContainer es una clase que simplifica la creacion y el manejo del Core Data stack en la app.
        //El Core Data stack es algo asi como un modelo para el manejo de objetos con persisitencia en memoria.
        //viewContext es una propiedad que esta asociada al hilo principal de la aplicacion, hace parte de la inicializacion del persistentContainer.
        let managedContextReference = appDelegateReference!.persistentContainer.viewContext
        
        //Se crea un objeto tipo NSFetchRequest, en esencia le decimos al buscador que nos traiga los objetos tipo NSManagedObject en el entity "Lista".
        //Fetch Request significa solicitud de busqueda o extracción.
        //NSFetchRequest es una clase generica que contine los criterios de busqueda y extracción de datos en un persistent store.
        //<NSManagedObject> es el tipo de resultado de la solicitud de extracción.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        do {
                //La función fetch busca la información con el objeto tipo NSFetchRequest construido anteriormente.
                palabrasTablaConManagedObject = try managedContextReference.fetch(fetchRequest)
            
        } catch let error as NSError {
            
            print("No se recuperaron los datos, info del error: \(error), \(error.userInfo)" )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Funcion que configura el numero de secciones que tendra la tabla.
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    //Función que configura el numero de filas que tendrá la tabla.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //La tabla tendrá el numero de filas que tenga el arreglo "palabrasTablaConManagedObject".
        return palabrasTablaConManagedObject.count
    }

    //Funcion donde se configura la celda.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Cambiamos el identificador por default y le colocamos Cell, que fue el identificador de celda que elegimos.
        //El metodo de instancia "dequeueReusableCell" retorna un objeto del tipo UITableViewCell para su reuso.
        //Por motivos de rendimiento, se reutilizan objetos UITableViewCell cuando se asignan celdas a filas en su método tableView: cellForRowAtIndexPath:
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        //textLabel devuelve el label principal de la tabla.
        //textLabel?.text es lo que se encuentra escrito en el label de la tabla.
        //indexPath.row comienza desde cero hasta el ultimo subindice del array.
        //cell.textLabel?.text = palabrasTabla[indexPath.row]     //Asigna cada unos de los elementos del array a las filas de la celda.
        
        //objetoManagedObject es un objeto que contendra cada uno de los objetos del array palabrasTablaConManagedObject a traves del indexPath.
        let objetoManagedObject = palabrasTablaConManagedObject[indexPath.row]
        
        //En esencia aqui agregamos la palabra guardada en el atributo palabra del objeto NSManagedObject casteado a String al textfield de la celda, para que aparezca en pantalla.
        //Se asigna el contenido del  objetoManagedObject asociado al atributo "palabra" a las filas de la celda.
        //"palabra" es el atributo del entity "Lista" asignada al objetoManagedObject, dado que objetoManagedObject pertenece al entity Lista.
        cell.textLabel?.text = objetoManagedObject.value(forKey: "palabra") as? String
    
        return cell
    }
    
    //Función para configurar las acciones del boton agregar.
    @IBAction func agregarPalabras(_ sender: Any)
    {
        //Se crea una alerta del tipo UIAlertController, con parametros como titulo, mensaje y estilo.
        let alerta = UIAlertController(title: "Nueva Palabra", message: "Por favor ingrese la nueva palabra", preferredStyle: .alert)
        
        //Se crea la accion guardar del tipo UIAlertAction, la cual guarda la palabra que ingrese el usuario.
        //El parametro handler es un bloque de ejecución que se realiza cuando se selecciona la accion, no tiene valor de retorno.
        //"Void in" significa que no se devuelve ningun valor y se invita a colocar el bloque de codigo que acompaña la accion.
        let guardar = UIAlertAction(title: "Guardar", style: .default, handler:{ (UIAlerAction) -> Void in
            
                                        //Accedemos a la propiedad alerta.textField en su primer elemento.
                                        let textField = alerta.textFields?.first
            
                                        //A traves de append agregamos el contenido de la constante textField al array palabrasTabla.
                                        //self.palabrasTabla.append((textField?.text)!)
            
                                        //Se llama a la función "guardarPalabra" y como parametro le agregamos el texto introducido por el usuario.
                                        self.guardarPalabra(palabraParametro: textField!.text!)
            
                                        self.tableView.reloadData()         //Actualiza la tabla con la nueva informacion.
                                    })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default) {(action:UIAlertAction) -> Void in}     //Accion de cancelar.
        
        
        alerta.addTextField {(textField: UITextField ) -> Void in}          //Añadimos a la alerta un textField.
        alerta.addAction(guardar)                                           //Añadimos la accion guardar a la alerta, el parametro es un UIAlertAction.
        alerta.addAction(cancelar)                                          //Añadimos la accion cancelar a la alerta.
        present(alerta, animated: true, completion: nil)                    //present "presenta" la alerta al usuario.
    }
    
    //Funcion donde se configura el proceso de guardar un dato con CoreData.
    func guardarPalabra(palabraParametro:String)
    {
        // a. Para guardar o recuperar datos en CoreData, necesitamos un objeto del tipo "managedObjectContext", podemos verlo como una libreta de borrador donde se trabaja con objetos del tipo "NSManagedObjects", primero se coloca un objeto de tipo "NSManagedObjects" en la libreta de borrador (managedObjectContext), una vez se tenga preparado el objeto (NSManagedObject), se indica a la libreta de borrador que lo guarde en el disco duro.
        
        // b. De acuerdo a lo anterior, entonces se crea un objeto NSManagedObjects, por medio de la definición de clase "Entity", y con la ayuda del objeto de tipo managedObjectContext.
        
        // c. Añadimos valores a las propiedades del objeto NSManagedObjects.
        
        // d. Con la ayuda del objeto managedObjectContext, guardamos los cambios.
 
        /*******************************************************************************************************************************************************/
        
        // Se crea una referencia al delegado de la aplicación.
        // La clase UIApplication proporciona un punto centralizado de control y coordinación para las aplicaciones que se ejecutan en iOS. Cada aplicación tiene exactamente una instancia de UIApplication.
        // La propiedad shared retorna la instancia singleton de la app.
        // Cada aplicación debe tener un objeto delegate para responder a los mensajes relacionados con la aplicación.
        let appDelegateReference = UIApplication.shared.delegate as? AppDelegate
        
        //Se crea una referencia del tipo managedObjectContext.
        //persistentContainer es una función declarada en la clase AppDelegate que crea y retorna un contenedor persistente.
        //viewContext es el managedObjectContext asociado con el hilo principal de la aplicación.
        let managedContextReference = appDelegateReference!.persistentContainer.viewContext
        
        
        //Creamos una referencia al Entity (a la clase).
        //NSEntityDescription.entity retorna un objeto NSEntityDescription, se debe ingresar el nombre del entity y la referencia del tipo NSManagedContext.
        let entityReference = NSEntityDescription.entity(forEntityName: "Lista", in: managedContextReference)!
        
        //Creamos un objeto tipo NSManagedObject utilizando su entity.
        let palabraManagedObject = NSManagedObject(entity: entityReference, insertInto: managedContextReference)
        
        //Seteamos el objeto NSManagedObject, ingresamos como parametros el texto escrito por el usuario y lo grabe en la llave "palabra".
        palabraManagedObject.setValue(palabraParametro, forKeyPath: "palabra")
        
        
        do {
            try
                //managedContextReference es un objeto del tipo managedObjectContext.
                //La función save() intenta guardar los datos, esta declarado como throws, lo cual indica que la función arrojará un error en caso de falla.
                managedContextReference.save()
            
                //Se agrega el objeto managedObject a el array de managed objects.
                //La función append agrega el elemento al final del array
                palabrasTablaConManagedObject.append(palabraManagedObject)
            
        } catch let error as NSError {
            
            print("No se pudo guardar, info del error: \(error), \(error.userInfo)" )
        }
    }
    
    
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
