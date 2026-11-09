package ecorescate;

import ecorescate.modelo.PerfilRepositorio;
import ecorescate.modelo.RegistroPartidas;
import ecorescate.ui.Sonido;
import ecorescate.ui.VentanaPrincipal;

import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import java.io.File;
import java.net.URISyntaxException;

/**
 * Operación EcoRescate: suite de minijuegos educativos para el cuidado del ambiente.
 * Punto de entrada de la aplicación.
 */
public class Main {

    private static File carpetaBase;

    public static void main(String[] args) {
        // Optimización gráfica de Java2D para PCs de laboratorio y gráficos integrados
        System.setProperty("sun.java2d.uiScale.enabled", "true");
        System.setProperty("swing.bufferPerWindow", "true");
        System.setProperty("sun.java2d.noddraw", "false");

        File datos = VentanaPrincipal.carpetaDatos();
        Sonido.get().iniciar(new File(datos, "config.properties"));

        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignorado) {
                // si falla, Swing usa su apariencia por defecto
            }
            RegistroPartidas registro = new RegistroPartidas(VentanaPrincipal.archivoPorDefecto());
            PerfilRepositorio perfiles = new PerfilRepositorio(new File(datos, "perfiles"));
            new VentanaPrincipal(registro, perfiles).setVisible(true);
        });
    }

    /** Devuelve la carpeta donde reside EcoRescate.jar (o user.dir si se ejecuta desde el IDE). */
    public static synchronized File carpetaPrograma() {
        if (carpetaBase != null) return carpetaBase;
        try {
            File ubicacion = new File(Main.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            File dir = ubicacion.isFile() ? ubicacion.getParentFile() : ubicacion;
            // Si se corre desde bin/ o target/, subir a la carpeta del proyecto si allí está src/
            if (dir != null && "bin".equalsIgnoreCase(dir.getName()) && dir.getParentFile() != null) {
                dir = dir.getParentFile();
            }
            if (dir != null && dir.exists() && dir.canWrite()) {
                carpetaBase = dir;
                return carpetaBase;
            }
        } catch (URISyntaxException | SecurityException | NullPointerException ignorado) {
            // usar carpeta actual como respaldo
        }
        File actual = new File(System.getProperty("user.dir", "."));
        if (actual.exists() && actual.canWrite()) {
            carpetaBase = actual;
        } else {
            carpetaBase = new File(System.getProperty("user.home", "."), "EcoRescate");
        }
        return carpetaBase;
    }
}
