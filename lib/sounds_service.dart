import 'dart:html' as html;
class SoundsService 
{
  static html.AudioElement? _backgroundMusic;
  static bool _isMuted = false;
  static bool get isMuted => _isMuted;

  static void playBackgtound() {
    _backgroundMusic = 
    html.AudioElement('sounds/background.mp3')
    ..loop = true
    ..volume = 0.4;
    if (!_isMuted){
      _backgroundMusic!.play();
    }
  }
  static void _playSounds(String path, {double volume = 1.0}){
    if (_isMuted) return;
    html.AudioElement(path)
    ..volume = volume
    ..play();
  }
  static void playWin() => _playSounds('sounds/win.mp3');
  static void playJackpot() =>
  _playSounds('sounds/jackpot.mp3');
  static void playLose() =>
  _playSounds('sound/lose.mp3', volume: 0.7);
  static void playClick() =>
  _playSounds('sounds/click.mp3', volume: 0.6);

  static void toggleMute(){
    _isMuted = !_isMuted;
    if (_isMuted){_backgroundMusic?.pause();}
    else{_backgroundMusic?.play();}
  }

  
}