package
{
import flash.display.Sprite;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.events.NetStatusEvent;
import flash.events.MouseEvent;
import flash.media.Camera;
import flash.media.Microphone;

import fl.controls.Button;
import fl.controls.TextArea;

[Frame(factoryClass="PreloaderNSPlay")]
public class NSPlay extends Sprite
{
	public function NSPlay()
	{
		_connBTN = new Button();
		_connBTN.label = '连接';
		_connBTN.addEventListener(MouseEvent.CLICK, handler_conn);
		_connBTN.move(0, 340);
		this.addChild(_connBTN);

		_ta = new TextArea();
		_ta.setSize(320, 100);
		_ta.move(0, 240);
		this.addChild(_ta);

		_video = new Video(320, 240);
		this.addChild(_video);

		_nc = new NetConnection();
		_nc.addEventListener(NetStatusEvent.NET_STATUS, handler_netStatus);

	}

	private var _nc:NetConnection;
	private var _ns:NetStream;
	private var _mic:Microphone;
	private var _cam:Camera;

	private var _connBTN:Button;
	private var _video:Video;
	private var _ta:TextArea;

	private function handler_conn($evt:MouseEvent):void
	{
		_nc.connect('rtmp://127.0.0.1/testspeed/1');
	}

	private function handler_netStatus($evt:NetStatusEvent):void
	{
		showInfo('nc status:',$evt.info.code);
		if($evt.info.code == "NetConnection.Connect.Success")
		{
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, handler_nsNetStatus);
			_ns.receiveVideo(true);
			_ns.receiveAudio(true);
			_ns.play('zrong');
			_video.attachNetStream(_ns);
		}
	}

	private function handler_nsNetStatus($evt:NetStatusEvent):void
	{
		showInfo('ns status:',$evt.info.code);
	}

	private function showInfo(...$info):void
	{
		if($info)
		{
			var __info:String = '';
			for each(var __str:String in $info)
			{
				__info += __str + '';
			}
			__info += '\n';
		}
		_ta.appendText(__info);
	}
}
}
