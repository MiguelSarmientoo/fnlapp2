import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fnlapp/SharedPreferences/sharedpreference.dart';
import 'package:fnlapp/Main/cargarprograma.dart';

class TestEstresQuestionScreen extends StatefulWidget {
  const TestEstresQuestionScreen({Key? key}) : super(key: key);

  @override
  _TestEstresQuestionScreenState createState() => _TestEstresQuestionScreenState();
}

class _TestEstresQuestionScreenState extends State<TestEstresQuestionScreen> {

  int currentQuestionIndex = 0;
  String? selectedOption;
  bool showDetail = false;
  final List<int?> selectedOptions = List<int?>.filled(23, null);  // Almacena las respuestas seleccionadas
  int? userId;
final List<Map<String, String>> questions = [
  {
    "question": "Tener que hacer reportes tanto para sus jefes como para las personas de su equipo le preocupa, porque siente que debe cumplir con las expectativas de todos y eso le genera tensión.",
    "description": "Rendir cuentas a varias personas puede generar presión. Veamos cómo manejas esta situación.",
    "option1": "Nunca",
    "detail1": "No sientes ninguna presión al hacer reportes, ¡genial!",
    "option2": "Raras veces",
    "detail2": "Solo en ocasiones te sientes tenso al hacer reportes.",
    "option3": "Ocasionalmente",
    "detail3": "A veces sientes algo de estrés al rendir informes.",
    "option4": "Algunas veces",
    "detail4": "En varias ocasiones te preocupa cumplir con los reportes.",
    "option5": "Frecuentemente",
    "detail5": "Rendir cuentas es una fuente frecuente de estrés para ti.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes presionado al hacer reportes.",
    "option7": "Siempre",
    "detail7": "Siempre te causa estrés hacer reportes para jefes y equipo."
  },
  {
    "question": "Si no puede controlar lo que sucede en su área de trabajo, se frustra, ya que le gusta tener todo bajo control y organizado.",
    "description": "El control es importante para sentirse en paz. Veamos cómo te afecta perder el control en tu área.",
    "option1": "Nunca",
    "detail1": "Siempre tienes todo bajo control, ¡excelente!",
    "option2": "Raras veces",
    "detail2": "Solo rara vez sientes que pierdes el control de tu área.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te sientes fuera de control en tu área de trabajo.",
    "option4": "Algunas veces",
    "detail4": "A veces pierdes el control, lo que te genera frustración.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te sientes sin control, lo que te estresa.",
    "option6": "Generalmente",
    "detail6": "Generalmente pierdes el control en tu área, lo que afecta tu rendimiento.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes fuera de control, lo que es una fuente constante de estrés."
  },
  {
    "question": "Si no cuenta con el equipo necesario para hacer su trabajo, se siente estresado porque no puede hacerlo de la mejor manera.",
    "description": "Contar con las herramientas adecuadas es clave para hacer un buen trabajo. Revisemos cómo te afecta la falta de recursos.",
    "option1": "Nunca",
    "detail1": "Siempre tienes el equipo necesario para tu trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que no tienes el equipo adecuado.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente no cuentas con el equipo necesario.",
    "option4": "Algunas veces",
    "detail4": "A veces no tienes el equipo que necesitas, lo que te estresa.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te falta equipo adecuado para hacer tu trabajo.",
    "option6": "Generalmente",
    "detail6": "Generalmente careces de equipo, lo que te genera presión.",
    "option7": "Siempre",
    "detail7": "Siempre te falta equipo, lo que es una constante fuente de estrés."
  },
  {
    "question": "Cuando su jefe no lo apoya o no habla bien de él frente a otros superiores, se siente solo y preocupado, pensando que no lo valoran.",
    "description": "Sentirse respaldado por tu jefe es esencial para el bienestar en el trabajo. Veamos cómo te afecta la falta de apoyo.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tu jefe te apoya y te valora.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes falta de apoyo por parte de tu jefe.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu jefe no te respalda.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes solo por la falta de apoyo de tu jefe.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente no sientes el apoyo de tu jefe, lo que te estresa.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes sin apoyo por parte de tu jefe.",
    "option7": "Siempre",
    "detail7": "Siempre sientes que tu jefe no te apoya, lo que genera un gran estrés."
  },
  {
    "question": "Si siente que su jefe no lo trata con respeto o no valora su trabajo, le causa mucho estrés.",
    "description": "Ser valorado y respetado en el trabajo es crucial para el bienestar. Veamos cómo te afecta cuando no te sientes valorado.",
    "option1": "Nunca",
    "detail1": "Siempre te sientes respetado y valorado por tu jefe.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes falta de respeto o valoración por parte de tu jefe.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu jefe no te valora lo suficiente.",
    "option4": "Algunas veces",
    "detail4": "A veces sientes que no te valoran ni respetan en el trabajo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te sientes sin respeto ni valoración por parte de tu jefe.",
    "option6": "Generalmente",
    "detail6": "Generalmente sientes falta de respeto o valoración, lo que te afecta.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes menospreciado por tu jefe, lo que es una gran fuente de estrés."
  },
  {
    "question": "No sentirse parte de un equipo de trabajo unido le hace sentirse aislado y preocupado por no poder colaborar eficientemente con otros.",
    "description": "Sentirse parte de un equipo unido es fundamental para el éxito en el trabajo. Revisemos cómo te afecta la falta de cohesión en tu equipo.",
    "option1": "Nunca",
    "detail1": "Siempre te sientes parte de un equipo unido y colaborativo.",
    "option2": "Raras veces",
    "detail2": "Rara vez te sientes aislado o fuera del equipo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te sientes desconectado de tu equipo.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes aislado y te preocupa no colaborar eficientemente.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te sientes fuera de lugar en tu equipo de trabajo.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes desconectado de tu equipo, lo que afecta tu rendimiento.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes aislado, lo que te genera mucho estrés y preocupación."
  },
  {
    "question": "Cuando su equipo de trabajo no lo apoya en alcanzar sus metas, se siente estresado y frustrado.",
    "description": "El apoyo del equipo es esencial para alcanzar tus metas. Veamos cómo te afecta cuando no recibes el respaldo necesario.",
    "option1": "Nunca",
    "detail1": "Siempre sientes el apoyo de tu equipo para alcanzar tus metas.",
    "option2": "Raras veces",
    "detail2": "Rara vez te sientes sin apoyo para alcanzar tus objetivos.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que no recibes suficiente respaldo.",
    "option4": "Algunas veces",
    "detail4": "A veces te falta el apoyo necesario de tu equipo, lo que te frustra.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que tu equipo no te ayuda a alcanzar tus metas.",
    "option6": "Generalmente",
    "detail6": "Generalmente careces de apoyo por parte de tu equipo, lo que te genera estrés.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes solo en la búsqueda de tus metas, lo que es una fuente importante de frustración."
  },
  {
    "question": "Sentir que su equipo de trabajo no tiene buena reputación dentro de la empresa le provoca estrés, ya que desea que su equipo sea valorado.",
    "description": "Tener una buena reputación en el trabajo es importante para la satisfacción personal. Veamos cómo te afecta la percepción de tu equipo.",
    "option1": "Nunca",
    "detail1": "Siempre consideras que tu equipo tiene una excelente reputación.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que la reputación de tu equipo está en juego.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te preocupa cómo se percibe a tu equipo dentro de la empresa.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes estresado porque la reputación de tu equipo no es la mejor.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te preocupa la imagen de tu equipo en la empresa.",
    "option6": "Generalmente",
    "detail6": "Generalmente sientes que tu equipo no es valorado dentro de la empresa.",
    "option7": "Siempre",
    "detail7": "Siempre te preocupa la reputación de tu equipo, lo que es una fuente de estrés constante."
  },
  {
    "question": "La falta de claridad en la forma de trabajar dentro de la empresa le genera confusión y estrés.",
    "description": "La claridad en los procesos de trabajo es clave para el rendimiento. Veamos cómo te afecta la falta de estructura.",
    "option1": "Nunca",
    "detail1": "Siempre sabes claramente cómo deben hacerse las cosas en la empresa.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes confusión por la falta de claridad en los procesos.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te sientes confundido por la falta de estructura en el trabajo.",
    "option4": "Algunas veces",
    "detail4": "A veces te causa estrés la falta de claridad en las tareas de la empresa.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te sientes desorientado por la falta de claridad en los procesos.",
    "option6": "Generalmente",
    "detail6": "Generalmente te afecta la falta de claridad en la forma de trabajar.",
    "option7": "Siempre",
    "detail7": "Siempre te estresa la falta de claridad en los procesos, lo que te genera frustración."
  },
  {
    "question": "Las políticas impuestas por la gerencia que dificultan su trabajo le causan frustración y estrés.",
    "description": "Las políticas de la empresa pueden facilitar o dificultar el trabajo. Veamos cómo te afecta cuando estas políticas son complicadas.",
    "option1": "Nunca",
    "detail1": "Siempre encuentras las políticas claras y útiles para tu trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez las políticas te dificultan el trabajo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente las políticas de la empresa te causan frustración.",
    "option4": "Algunas veces",
    "detail4": "A veces las políticas te impiden desempeñar bien tu trabajo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente las políticas de la empresa son una fuente de estrés para ti.",
    "option6": "Generalmente",
    "detail6": "Generalmente te cuesta lidiar con las políticas que impone la gerencia.",
    "option7": "Siempre",
    "detail7": "Siempre te frustran las políticas de la empresa, lo que afecta tu rendimiento."
  },
  {
    "question": "Cuando siente que no tiene suficiente control sobre su trabajo, igual que sus compañeros, se siente estresado y sin poder sobre lo que sucede.",
    "description": "Sentir que no tienes control sobre tu trabajo puede ser frustrante. Veamos cómo te afecta esta situación.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tienes control sobre tu trabajo, ¡genial!",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que pierdes el control sobre tu trabajo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que no tienes el control suficiente.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes fuera de control en tu trabajo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te preocupa la falta de control sobre lo que sucede en tu área.",
    "option6": "Generalmente",
    "detail6": "Generalmente sientes que no tienes suficiente control sobre lo que haces.",
    "option7": "Siempre",
    "detail7": "Siempre te estresa no tener control sobre tu trabajo, lo que es una constante fuente de tensión."
  },
  {
    "question": "Si percibe que su supervisor no se preocupa por su bienestar, se siente menospreciado y estresado.",
    "description": "Sentir que tu jefe se preocupa por tu bienestar es importante. Veamos cómo te afecta cuando no lo sientes así.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tu supervisor se preocupa por tu bienestar.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que tu supervisor no se preocupa por ti.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu jefe no se preocupa por tu bienestar.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes menospreciado porque tu jefe no se preocupa por ti.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que tu supervisor no se interesa en tu bienestar.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes sin apoyo de tu jefe, lo que te causa estrés.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes desatendido por tu supervisor, lo que genera mucho estrés."
  },
  {
    "question": "No contar con el conocimiento técnico necesario para competir en la empresa le genera una sensación de inseguridad y estrés.",
    "description": "Tener el conocimiento técnico adecuado es crucial para competir. Veamos cómo te afecta la falta de habilidades técnicas.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tienes el conocimiento técnico necesario para desempeñar tu trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que te falta conocimiento técnico.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te falta el conocimiento técnico necesario.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes inseguro porque no tienes las habilidades técnicas necesarias.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que no puedes competir debido a tu falta de conocimientos técnicos.",
    "option6": "Generalmente",
    "detail6": "Generalmente te afecta la falta de conocimiento técnico, lo que genera estrés.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes inseguro por no tener el conocimiento técnico necesario para competir en la empresa."
  },
  {
    "question": "No tener un espacio privado para trabajar en tranquilidad le incomoda y le estresa.",
    "description": "Tener un espacio adecuado para trabajar es esencial. Veamos cómo te afecta la falta de privacidad en tu área de trabajo.",
    "option1": "Nunca",
    "detail1": "Siempre cuentas con un espacio privado adecuado para trabajar.",
    "option2": "Raras veces",
    "detail2": "Rara vez te incomoda no tener privacidad en tu espacio de trabajo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te molesta no tener un espacio privado para trabajar.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes estresado por la falta de privacidad en el trabajo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te incomoda no tener un espacio adecuado para concentrarte.",
    "option6": "Generalmente",
    "detail6": "Generalmente te estresa no contar con un espacio privado, lo que afecta tu rendimiento.",
    "option7": "Siempre",
    "detail7": "Siempre te afecta no tener un espacio privado para trabajar, lo que genera mucho estrés."
  },
  {
    "question": "La carga de papeleo excesivo en la empresa le resulta abrumadora y le provoca estrés.",
    "description": "El exceso de papeleo puede ser una fuente importante de estrés. Veamos cómo te afecta.",
    "option1": "Nunca",
    "detail1": "Nunca sientes que el papeleo te abruma, ¡genial!",
    "option2": "Raras veces",
    "detail2": "Rara vez te sientes abrumado por el papeleo en la empresa.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que el papeleo es excesivo.",
    "option4": "Algunas veces",
    "detail4": "A veces te resulta abrumador la cantidad de papeleo que tienes que manejar.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te estresas por el exceso de papeleo.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes abrumado por la cantidad de papeleo que debes manejar.",
    "option7": "Siempre",
    "detail7": "Siempre te resulta muy estresante la carga de papeleo en la empresa."
  },
  {
    "question": "La falta de confianza de su supervisor en su trabajo le hace sentir inseguro y estresado.",
    "description": "Tener la confianza de tu jefe es importante para tu seguridad laboral. Veamos cómo te afecta cuando sientes que tu supervisor no confía en ti.",
    "option1": "Nunca",
    "detail1": "Siempre sientes la confianza de tu supervisor en tu trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que tu supervisor duda de ti.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu jefe no confía en tu trabajo.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes inseguro porque tu supervisor no confía en ti.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que tu jefe no confía en tu desempeño.",
    "option6": "Generalmente",
    "detail6": "Generalmente te afecta la falta de confianza de tu supervisor en tu trabajo.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes inseguro por la falta de confianza de tu supervisor, lo que te genera mucho estrés."
  },
  {
    "question": "Si su equipo de trabajo está desorganizado, se siente ansioso porque no puede trabajar de manera efectiva.",
    "description": "La organización dentro del equipo es clave para el éxito. Veamos cómo te afecta cuando tu equipo está desorganizado.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tu equipo está bien organizado, lo que facilita tu trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes que la desorganización del equipo te afecta.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu equipo es desorganizado.",
    "option4": "Algunas veces",
    "detail4": "A veces te sientes ansioso cuando tu equipo no está bien organizado.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te afecta la desorganización de tu equipo, lo que dificulta tu trabajo.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes ansioso por la falta de organización en tu equipo.",
    "option7": "Siempre",
    "detail7": "Siempre te causa mucho estrés trabajar con un equipo desorganizado."
  },
  {
    "question": "Cuando su equipo no lo protege de las demandas laborales injustas de los jefes, se siente desamparado y estresado.",
    "description": "El respaldo de tu equipo frente a las demandas laborales es clave. Veamos cómo te afecta cuando no sientes este apoyo.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que tu equipo te respalda frente a demandas injustas.",
    "option2": "Raras veces",
    "detail2": "Rara vez te sientes sin apoyo cuando enfrentas demandas laborales injustas.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te sientes desprotegido frente a las demandas laborales.",
    "option4": "Algunas veces",
    "detail4": "A veces sientes que tu equipo no te apoya lo suficiente en situaciones laborales difíciles.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te sientes sin protección frente a demandas laborales injustas.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes desamparado por la falta de respaldo de tu equipo.",
    "option7": "Siempre",
    "detail7": "Siempre te afecta no recibir apoyo de tu equipo ante demandas laborales injustas."
  },
  {
    "question": "La falta de dirección clara y objetivos definidos en la empresa le genera estrés e incertidumbre.",
    "description": "Tener una dirección clara es esencial para el bienestar laboral. Veamos cómo te afecta la falta de objetivos claros en la empresa.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que la empresa tiene una dirección clara y objetivos bien definidos.",
    "option2": "Raras veces",
    "detail2": "Rara vez te afecta la falta de claridad en los objetivos de la empresa.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te genera incertidumbre la falta de objetivos claros en la empresa.",
    "option4": "Algunas veces",
    "detail4": "A veces sientes que la falta de dirección clara te afecta y te genera estrés.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te afecta la falta de objetivos claros y definidos en la empresa.",
    "option6": "Generalmente",
    "detail6": "Generalmente sientes estrés por la falta de dirección clara en la empresa.",
    "option7": "Siempre",
    "detail7": "Siempre te genera mucho estrés la falta de objetivos claros en la empresa, lo que afecta tu desempeño."
  },
  {
    "question": "Si siente que su equipo lo presiona demasiado, se estresa porque siente que no puede cumplir con todo.",
    "description": "El apoyo del equipo es esencial para manejar la carga laboral. Veamos cómo te afecta cuando sientes que te presionan demasiado.",
    "option1": "Nunca",
    "detail1": "Nunca sientes que tu equipo te presiona más de lo necesario.",
    "option2": "Raras veces",
    "detail2": "Rara vez sientes presión excesiva por parte de tu equipo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que tu equipo te presiona demasiado.",
    "option4": "Algunas veces",
    "detail4": "A veces sientes que no puedes cumplir con todo debido a la presión de tu equipo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que la presión de tu equipo es una fuente importante de estrés.",
    "option6": "Generalmente",
    "detail6": "Generalmente sientes que tu equipo te exige demasiado, lo que te afecta.",
    "option7": "Siempre",
    "detail7": "Siempre te estresa la presión que recibes de tu equipo, lo que genera una gran carga emocional."
  },
  {
    "question": "Cuando no respetan a sus superiores, a él mismo, o a las personas que están por debajo de él, siente estrés e incomodidad.",
    "description": "El respeto es esencial en el ambiente de trabajo. Veamos cómo te afecta cuando no lo sientes hacia ti o los demás.",
    "option1": "Nunca",
    "detail1": "Siempre sientes que se respeta a todos en el entorno laboral, lo que genera un ambiente sano.",
    "option2": "Raras veces",
    "detail2": "Rara vez percibes una falta de respeto hacia ti o hacia otros.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te sientes incómodo por la falta de respeto en el ambiente laboral.",
    "option4": "Algunas veces",
    "detail4": "A veces te estresa ver que no respetan a tus superiores o a ti mismo.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes incomodidad por la falta de respeto hacia ti o los demás en el trabajo.",
    "option6": "Generalmente",
    "detail6": "Generalmente te afecta la falta de respeto en el ambiente laboral.",
    "option7": "Siempre",
    "detail7": "Siempre te estresa la falta de respeto hacia ti y los demás, lo que afecta tu bienestar."
  },
  {
    "question": "Si su equipo de trabajo no le brinda apoyo técnico cuando lo necesita, se siente frustrado y estresado.",
    "description": "Contar con el apoyo técnico de tu equipo es esencial. Veamos cómo te afecta cuando no recibes este respaldo.",
    "option1": "Nunca",
    "detail1": "Siempre cuentas con el apoyo técnico que necesitas, lo que te facilita el trabajo.",
    "option2": "Raras veces",
    "detail2": "Rara vez te falta apoyo técnico por parte de tu equipo.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente sientes que no recibes suficiente ayuda técnica.",
    "option4": "Algunas veces",
    "detail4": "A veces te falta apoyo técnico, lo que te genera frustración.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente sientes que no tienes el soporte técnico adecuado.",
    "option6": "Generalmente",
    "detail6": "Generalmente te falta el apoyo técnico necesario, lo que afecta tu rendimiento.",
    "option7": "Siempre",
    "detail7": "Siempre te sientes frustrado por la falta de ayuda técnica en tu equipo."
  },
  {
    "question": "La falta de tecnología adecuada para realizar un trabajo de calidad le genera una gran presión y estrés.",
    "description": "Contar con la tecnología adecuada es clave para hacer un buen trabajo. Veamos cómo te afecta cuando no tienes las herramientas necesarias.",
    "option1": "Nunca",
    "detail1": "Siempre cuentas con la tecnología adecuada para hacer tu trabajo eficientemente.",
    "option2": "Raras veces",
    "detail2": "Rara vez te falta tecnología para realizar tu trabajo de manera efectiva.",
    "option3": "Ocasionalmente",
    "detail3": "Ocasionalmente te falta la tecnología necesaria, lo que te genera estrés.",
    "option4": "Algunas veces",
    "detail4": "A veces sientes presión por no contar con la tecnología adecuada.",
    "option5": "Frecuentemente",
    "detail5": "Frecuentemente te afecta la falta de herramientas tecnológicas para hacer un trabajo de calidad.",
    "option6": "Generalmente",
    "detail6": "Generalmente te sientes presionado por la falta de tecnología adecuada en tu entorno de trabajo.",
    "option7": "Siempre",
    "detail7": "Siempre te genera mucha presión y estrés no contar con la tecnología necesaria para realizar tu trabajo de manera eficiente."
  }
];

@override
  void initState() {
    super.initState();
    _loadUserId();  // Cargamos el ID del usuario al iniciar
  }

  // Función para cargar el userId desde SharedPreferences
  Future<void> _loadUserId() async {
    int? id = await getUserId();  // Función que obtienes de SharedPreferences
    setState(() {
      userId = id;
    });
  }

  // Función para seleccionar una opción
  void selectOption(int optionId) {
    setState(() {
      selectedOption = 'option$optionId';  // Almacena la opción seleccionada
      selectedOptions[currentQuestionIndex] = optionId;  // Guarda la respuesta para la pregunta actual
      showDetail = true;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        showDetail = false;  // Oculta los detalles al pasar a la siguiente pregunta
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedOption = null;
        showDetail = false;  // Oculta los detalles al regresar a la pregunta anterior
      });
    }
  }

  Future<void> submitTest() async {
  final url = Uri.parse('http://localhost:3000/api/guardarTestEstres'); // URL para guardar el test de estrés
  final updateEstresUrl = Uri.parse('http://localhost:3000/api/userestresessions/assign'); // URL para actualizar el estres_nivel_id
  final programaUrl = Uri.parse('http://localhost:3000/api/userprograma/report/$userId'); // URL para generar el programa

  final Map<String, dynamic> data = {
    'user_id': userId,
    'pregunta_1': selectedOptions[0],
    'pregunta_2': selectedOptions[1],
    'pregunta_3': selectedOptions[2],
    'pregunta_4': selectedOptions[3],
    'pregunta_5': selectedOptions[4],
    'pregunta_6': selectedOptions[5],
    'pregunta_7': selectedOptions[6],
    'pregunta_8': selectedOptions[7],
    'pregunta_9': selectedOptions[8],
    'pregunta_10': selectedOptions[9],
    'pregunta_11': selectedOptions[10],
    'pregunta_12': selectedOptions[11],
    'pregunta_13': selectedOptions[12],
    'pregunta_14': selectedOptions[13],
    'pregunta_15': selectedOptions[14],
    'pregunta_16': selectedOptions[15],
    'pregunta_17': selectedOptions[16],
    'pregunta_18': selectedOptions[17],
    'pregunta_19': selectedOptions[18],
    'pregunta_20': selectedOptions[19],
    'pregunta_21': selectedOptions[20],
    'pregunta_22': selectedOptions[21],
    'pregunta_23': selectedOptions[22],
    'estado': 'activo',
  };

  // Calcular el totalScore basado en las opciones seleccionadas
  int totalScore = selectedOptions.fold(0, (sum, value) => sum + (value ?? 0));

  try {
    // Inicializa la variable nivelEstres con un valor predeterminado
    String nivelEstres = ''; // Asignar valor inicial por si acaso no se actualiza
    int estresNivelId = 0; // Inicializamos con el valor de LEVE (1)

    // Primero obtenemos el gender_id desde la API para determinar el género del usuario
    final genderResponse = await http.get(
      Uri.parse('http://localhost:3000/api/userResponses/$userId'),
    );

    if (genderResponse.statusCode == 200) {
      final List<dynamic> userData = json.decode(genderResponse.body);
      int genderId = userData[0]['gender_id']; // Obtenemos el gender_id del usuario

      // Calcular el nivel de estrés basado en el totalScore y el género
      if (totalScore <= 92) {
        nivelEstres = 'LEVE';
        estresNivelId = 1; // LEVE
      } else if (totalScore > 92 && totalScore <= 138) {
        if (genderId == 1 || genderId == null) {
          nivelEstres = 'MODERADO';
          estresNivelId = 2; // MODERADO
        } else if (genderId == 2) {
          if (totalScore <= 132) {
            nivelEstres = 'MODERADO';
            estresNivelId = 2;
          } else {
            nivelEstres = 'ALTO';
            estresNivelId = 3; // ALTO
          }
        }
      } else if (totalScore <= 161) {
        if (genderId == 1 || genderId == null) {
          if (totalScore > 138) {
            nivelEstres = 'ALTO';
            estresNivelId = 3;
          }
        } else if (genderId == 2) {
          if (totalScore > 132) {
            nivelEstres = 'ALTO';
            estresNivelId = 3;
          }
        }
      }

      print('Nivel de Estrés del usuario logeado: $nivelEstres');

      // Ahora hacemos la llamada para guardar el test con los datos del nivel de estrés
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Si el test de estrés se guarda correctamente, actualizamos el nivel de estrés
        final Map<String, dynamic> updateData = {
          'user_id': userId,
          'estres_nivel_id': estresNivelId,
        };

        final updateResponse = await http.post(
          updateEstresUrl,
          headers: {"Content-Type": "application/json"},
          body: json.encode(updateData),
        );

        if (updateResponse.statusCode == 200) {
          // Aquí lanzamos la tercera API de forma asincrónica sin bloquear la UI
          sendAsyncProgramaRequest(userId?.toString() ?? '', data);


          // Redirigir a la pantalla de carga de inmediato
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CargarProgramaScreen(nivelEstres: nivelEstres),
            ),
          );
        } else {
          print('Error al actualizar el estres_nivel_id: ${updateResponse.body}');
        }
      } else {
        print('Error: ${response.body}');
      }
    } else {
      print('Error al obtener el gender_id: ${genderResponse.statusCode}');
    }
  } catch (e) {
    print('Error al enviar el test: $e');
  }
}

// Función para enviar la tercera API de forma asincrónica
Future<void> sendAsyncProgramaRequest(String userId, Map<String, dynamic> data) async {
  final programaUrl = Uri.parse('http://localhost:3000/api/userprograma/report/$userId');

  try {
    // Enviar la petición de forma asíncrona
    final programaResponse = await http.post(
      programaUrl,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (programaResponse.statusCode == 200) {
      print('Programa generado correctamente');
    } else {
      print('Error al generar el programa: ${programaResponse.body}');
    }
  } catch (e) {
    print('Error al enviar la solicitud para generar el programa: $e');
  }
}





  @override
Widget build(BuildContext context) {
  final question = questions[currentQuestionIndex];

  return Scaffold(
    body: SingleChildScrollView( // Envolver el contenido principal en un SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Text(
              question['question'] ?? '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              question['description'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            if (question['image'] != null && question['image']!.isNotEmpty)
              Image.asset(
                question['image'] ?? '',
                height: 120,
              ),
            SizedBox(height: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 1; i <= 7; i++)
                  GestureDetector(
                    onTap: () => selectOption(i),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selectedOption == 'option$i' ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['option$i'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedOption == 'option$i' ? Colors.white : Colors.black,
                              fontFamily: 'NotoColorEmoji',
                            ),
                          ),
                          if (selectedOption == 'option$i' && showDetail)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                question['detail$i'] ?? '',
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20), // Espacio adicional para el botón
            if (currentQuestionIndex > 0)
              TextButton(
                onPressed: goToPreviousQuestion,
                child: Text(
                  'Volver',
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: selectedOption != null
                  ? (currentQuestionIndex == questions.length - 1 ? submitTest : goToNextQuestion)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption != null ? Color.fromARGB(255, 75, 29, 154) : Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 40),
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1 ? 'Finalizar' : 'Siguiente',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 30), // Asegurar suficiente espacio al final
          ],
        ),
      ),
    ),
  );
}

}
