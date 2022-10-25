import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0.7,
      overlayColor: AppColors.black,
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarDefault('Política de Privacidade')),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              children: const [
                ///Texto da política
                Text('''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras eget imperdiet est, et finibus ligula. Nulla venenatis sit amet massa id laoreet. Aenean eu egestas urna. In non dictum nibh. Proin vitae metus eleifend, fringilla quam eget, vestibulum tellus. Fusce sit amet magna consequat, suscipit tortor in, vehicula mi. Morbi consectetur imperdiet pharetra. Fusce vel condimentum ipsum. Proin pharetra mi ac quam sagittis, non varius dui commodo.
                
Vestibulum nec ornare tortor, dignissim viverra tellus. Mauris tempus fringilla sem vel consequat. Nunc tincidunt eu justo quis sodales. Nunc commodo, risus ac lobortis tincidunt, tortor neque efficitur mauris, sagittis ornare felis nisi convallis nisl. Mauris et cursus sapien, ut varius leo. Fusce id tellus quis massa facilisis scelerisque. Maecenas tincidunt rhoncus gravida. Integer sed lorem non leo cursus tempor. Praesent ac interdum est, non feugiat erat. Nulla porta dignissim lorem, eget laoreet lorem accumsan ac. Sed pellentesque ante sit amet magna porttitor pretium. Suspendisse fringilla imperdiet est, quis elementum nisl cursus ac. Aenean porttitor, ligula et porta molestie, ex nunc vulputate magna, at sagittis augue ipsum ac neque. Integer vulputate mollis leo eget tincidunt.
                
Vestibulum elit nibh, dapibus id diam vitae, faucibus consequat risus. Aenean non tellus sed nibh laoreet rhoncus. In sodales diam et enim lobortis, ac tincidunt ante pellentesque. Suspendisse a nisi ac lorem venenatis ultricies. Fusce dolor quam, finibus vitae risus eget, pharetra tincidunt ante. In rutrum nisl eu sapien fermentum varius. Praesent tincidunt consequat orci. Nam ultricies turpis massa, sed pretium ex placerat sit amet. Ut laoreet ligula est, id pretium ante lacinia eu. Nunc id enim vehicula, tincidunt nulla ac, iaculis est.
                
Vestibulum nec ornare tortor, dignissim viverra tellus. Mauris tempus fringilla sem vel consequat. Nunc tincidunt eu justo quis sodales. Nunc commodo, risus ac lobortis tincidunt, tortor neque efficitur mauris, sagittis ornare felis nisi convallis nisl. Mauris et cursus sapien, ut varius leo. Fusce id tellus quis massa facilisis scelerisque. Maecenas tincidunt rhoncus gravida. Integer sed lorem non leo cursus tempor. Praesent ac interdum est, non feugiat erat. Nulla porta dignissim lorem, eget laoreet lorem accumsan ac. Sed pellentesque ante sit amet magna porttitor pretium. Suspendisse fringilla imperdiet est, quis elementum nisl cursus ac. Aenean porttitor, ligula et porta molestie, ex nunc vulputate magna, at sagittis augue ipsum ac neque. Integer vulputate mollis leo eget tincidunt.
                
Vestibulum elit nibh, dapibus id diam vitae, faucibus consequat risus. Aenean non tellus sed nibh laoreet rhoncus. In sodales diam et enim lobortis, ac tincidunt ante pellentesque. Suspendisse a nisi ac lorem venenatis ultricies. Fusce dolor quam, finibus vitae risus eget, pharetra tincidunt ante. In rutrum nisl eu sapien fermentum varius. Praesent tincidunt consequat orci. Nam ultricies turpis massa, sed pretium ex placerat sit amet. Ut laoreet ligula est, id pretium ante lacinia eu. Nunc id enim vehicula, tincidunt nulla ac, iaculis est.
                
Vestibulum nec ornare tortor, dignissim viverra tellus. Mauris tempus fringilla sem vel consequat. Nunc tincidunt eu justo quis sodales. Nunc commodo, risus ac lobortis tincidunt, tortor neque efficitur mauris, sagittis ornare felis nisi convallis nisl. Mauris et cursus sapien, ut varius leo. Fusce id tellus quis massa facilisis scelerisque. Maecenas tincidunt rhoncus gravida. Integer sed lorem non leo cursus tempor. Praesent ac interdum est, non feugiat erat. Nulla porta dignissim lorem, eget laoreet lorem accumsan ac. Sed pellentesque ante sit amet magna porttitor pretium. Suspendisse fringilla imperdiet est, quis elementum nisl cursus ac. Aenean porttitor, ligula et porta molestie, ex nunc vulputate magna, at sagittis augue ipsum ac neque. Integer vulputate mollis leo eget tincidunt.
                
Vestibulum elit nibh, dapibus id diam vitae, faucibus consequat risus. Aenean non tellus sed nibh laoreet rhoncus. In sodales diam et enim lobortis, ac tincidunt ante pellentesque. Suspendisse a nisi ac lorem venenatis ultricies. Fusce dolor quam, finibus vitae risus eget, pharetra tincidunt ante. In rutrum nisl eu sapien fermentum varius. Praesent tincidunt consequat orci. Nam ultricies turpis massa, sed pretium ex placerat sit amet. Ut laoreet ligula est, id pretium ante lacinia eu. Nunc id enim vehicula, tincidunt nulla ac, iaculis est.
                
Vestibulum nec ornare tortor, dignissim viverra tellus. Mauris tempus fringilla sem vel consequat. Nunc tincidunt eu justo quis sodales. Nunc commodo, risus ac lobortis tincidunt, tortor neque efficitur mauris, sagittis ornare felis nisi convallis nisl. Mauris et cursus sapien, ut varius leo. Fusce id tellus quis massa facilisis scelerisque. Maecenas tincidunt rhoncus gravida. Integer sed lorem non leo cursus tempor. Praesent ac interdum est, non feugiat erat. Nulla porta dignissim lorem, eget laoreet lorem accumsan ac. Sed pellentesque ante sit amet magna porttitor pretium. Suspendisse fringilla imperdiet est, quis elementum nisl cursus ac. Aenean porttitor, ligula et porta molestie, ex nunc vulputate magna, at sagittis augue ipsum ac neque. Integer vulputate mollis leo eget tincidunt.
                
Vestibulum elit nibh, dapibus id diam vitae, faucibus consequat risus. Aenean non tellus sed nibh laoreet rhoncus. In sodales diam et enim lobortis, ac tincidunt ante pellentesque. Suspendisse a nisi ac lorem venenatis ultricies. Fusce dolor quam, finibus vitae risus eget, pharetra tincidunt ante. In rutrum nisl eu sapien fermentum varius. Praesent tincidunt consequat orci. Nam ultricies turpis massa, sed pretium ex placerat sit amet. Ut laoreet ligula est, id pretium ante lacinia eu. Nunc id enim vehicula, tincidunt nulla ac, iaculis est.
                      ''')
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
