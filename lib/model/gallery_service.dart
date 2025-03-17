import 'package:image_picker/image_picker.dart';

/// Servicio para manejar la seleccion de imagenes de la galeria.
///
/// Esta clase utiliza `ImagePicker` para abrir la galeria del dispositivo y
/// permitir al usuario seleccionar una imagen.
///
/// Devuelve la ruta de la imagen seleccionada o `null` si se cancela la selección.
class GalleryService {
  // IMAGEPICKER PARA SELECCIONAR IMAGENES
  final ImagePicker _picker = ImagePicker();

  /// Abre la galeria y permite al usuario seleccionar una imagen.
  ///
  /// Retorna la ruta de la imagen seleccionada o `null` si no se selecciona ninguna imagen
  Future<String?> selectPhoto() async {
    // ABRIR LA GALERIA Y PERMITIR AL USUARIO SELECCIONAR UNA IMAGEN
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery, // GALERIA
    );

    // SI NO SE SELECCIONA UNA IMAGEN, RETORNAR NULL
    if (photo == null) return null;

    // RETORNAR LA RUTA DE LA IMAGEN SELECCIONADA
    return photo.path;
  } // METODO PARA SELECCIONAR UNA FOTO DESDE LA GALERIA
}
