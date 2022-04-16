<?php 

require "conn.php";


	if ($_SERVER['REQUEST_METHOD']=="POST") {

		$response = array();
		$email=$_POST['email'];
		$password=$_POST['password'];

		$query = "SELECT * FROM users where email='$email' and password ='$password'";

		$result=mysqli_fetch_array(mysqli_query($conn,$query));

		if (isset($result)) {
			$response['value']=1;
			$response['message']='login sukses';

			$response['data']=$result['facePoint'];
			$response['username']=$result['username'];

			echo json_encode($response);
			# code...
		}else{
			$response['value']=0;
			$response['message']="Login gagal";
			echo json_encode($response);
		}

		# code...
	}
 ?>