
### This is currently broken.

@tool
extends AeroMover3D
class_name AeroRotorHinge3D

## Length of the simulated blade, from the hinge root, to the tip.
@export var blade_length : float = 10.0
## Mass of the simulated blade.
@export var blade_mass : float = 100.0

var flap_velocity : float = 0.0
var leadlag_velocity : float = 0.0

var flap : float = 0.0
var leadlag : float = 0.0

@onready var rotation_z : float = rotation.z
@onready var rotation_y : float = rotation.y

func _update_transform_substep(substep_delta : float) -> void:
	super._update_transform_substep(substep_delta)
	
	#should we use the torque instead of the force?
	var force : Vector3 = _current_force * global_basis
	var linear_acceleration : Vector3 = get_linear_acceleration() * global_basis
	
	leadlag_velocity += force.z / blade_mass * substep_delta #might need to be negative
	leadlag_velocity += linear_acceleration.z * substep_delta
	leadlag += leadlag_velocity * substep_delta
	
	#if not leadlag == clamp(leadlag, -0.5, 0.5):
		#leadlag = clamp(leadlag, -0.5, 0.5) - 0.05 * sign(leadlag)
		#leadlag_velocity = 0.0
	
	
	# lead-lag and flap velocity isn't integrated properly by AeroMover3D
	
	#need conservation of angular momentum
	
	#need option for "delta 3" feathering control
	
	flap_velocity = force.y / blade_mass * substep_delta
	flap_velocity += -linear_acceleration.y * substep_delta
	flap += flap_velocity * substep_delta
	
	#if not flap == clamp(flap, -0.5, 0.5):
		#flap = clamp(flap, -0.5, 0.5) - 0.05 * sign(flap)
		#flap_velocity = 0.0
	
	rotation.z = rotation_z + flap
	rotation.y = rotation_y + leadlag

func get_centrifugal_offset() -> Vector3:
	return position + Vector3(blade_length * 0.5, 0, 0)



#heli wing flapper fixed update
#// Token: 0x06005A91 RID: 23185 RVA: 0x0021B9AC File Offset: 0x00219BAC
		#private void FixedUpdate()
		#{
			#if (!this.sampleWings[0].rb.isKinematic)
			#{
				#Vector3 vector = Vector3.zero;
				#for (int i = 0; i < this.sampleWings.Length; i++)
				#{
					#vector += this.sampleWings[i].liftVector;
				#}
				#vector *= this.flapFactor;
				#if (this.doWeight)
				#{
					#Vector3 vector2 = Physics.gravity * this.weight;
					#if (this.rotor.inputShaft.outputRPM > 0f)
					#{
						#vector2 *= Mathf.Clamp01(60f / (this.centrifugalFactor * this.rotor.inputShaft.outputRPM));
					#}
					#vector += vector2;
					#vector += (-this.f * this.spring + -this.flapSpeed * this.damper) * base.transform.parent.up;
				#}
				#float num = Vector3.Dot(vector, base.transform.parent.up);
				#if (this.doWeight)
				#{
					#this.flapSpeed += num / this.weight * Time.fixedDeltaTime;
					#this.f += this.flapSpeed * Time.fixedDeltaTime;
					#if (Mathf.Abs(this.f) > this.maximumFlap)
					#{
						#this.flapSpeed = 0f;
						#this.f = Mathf.Clamp(this.f, -this.maximumFlap, this.maximumFlap);
					#}
				#}
				#else
				#{
					#this.f = Mathf.Clamp(num, -this.maximumFlap, this.maximumFlap);
				#}
				#this.currentFlap = (this.baseFlap = this.f);
				#if (this.oppositeFlap)
				#{
					#this.currentFlap -= this.oppositeFlap.baseFlap * this.counterFlapFactor;
				#}
				#base.transform.localRotation = Quaternion.AngleAxis(-this.currentFlap, this.localAxis) * this.origRot;
			#}
		#}

#helicopter rotor fixed update
#private void FixedUpdate()
		#{
			#bool num = !rb.isKinematic;
			#float num2 = inputShaft.outputRPM * 6f;
			#if (zeroSpring && num2 < zeroSpringMaxSpeed && inputShaft.rotationAcceleration <= 0f)
			#{
				#zeroSpringPid.updateMode = UpdateModes.Fixed;
				#float num3 = Mathf.Clamp(zeroSpringPid.Evaluate(rotorAngle, 180f), 0f - maxZeroSpringRate, maxZeroSpringRate);
				#rotationVelocity += num3 * Time.fixedDeltaTime;
			#}
			#float num4 = inputShaft.outputRPM * 0.10472f;
			#Vector3 zero = Vector3.zero;
			#if (num && useCSPT)
			#{
				#zero.x += collectiveSpeedPitchTrim.Evaluate(inputCollective * rb.velocity.magnitude);
			#}
			#if (num && doDiscTilt)
			#{
				#Transform[] array = discTiltRefTransforms;
				#Vector3 vector = -(new Plane(array[0].position, array[1].position, array[2].position).normal + new Plane(array[2].position, array[3].position, array[0].position).normal);
				#localDiscAxis = base.transform.InverseTransformDirection(vector);
				#Debug.DrawLine(rotationTransform.position, rotationTransform.position + vector);
				#if ((bool)outputDiscTiltTf)
				#{
					#outputDiscTiltTf.rotation = Quaternion.LookRotation(vector);
				#}
			#}
			#Vector3 inducedFlow = Vector3.zero;
			#if (num && doInducedFlow)
			#{
				#inducedFlow = CalculateInducedFlow();
			#}
			#if (!num)
			#{
				#return;
			#}
			#dragTorque = 0f;
			#for (int i = 0; i < blades.Length; i++)
			#{
				#RotorBlade rotorBlade = blades[i];
				#float num5 = num4 * rotorBlade.radius;
				#Vector3 vector2 = rotorBlade.tangentialDirection * num5;
				#float num6 = (vector2 + rb.velocity).magnitude * rb.velocity.magnitude;
				#vector2 += CalculateFlapVelocity(rotorBlade.wing.transform.position, num6 * inputCollective);
				#if (doInducedFlow)
				#{
					#vector2 += CalculateInducedFlowAtPosition(rotorBlade.wing.transform.position, inducedFlow);
				#}
				#rotorBlade.wing.SetRotorVelocity(vector2);
				#dragTorque += Vector3.Dot(rotorBlade.wing.dragVector + rotorBlade.wing.liftVector, -rotorBlade.tangentialDirection) * 1000f * rotorBlade.radius;
				#Vector3 vector3 = inputPYR + pyrTrim;
				#vector3 += zero;
				#Quaternion localRotation = Quaternion.AngleAxis(Mathf.Clamp(0f + rotorBlade.cyclicPitchFactor * vector3.x + rotorBlade.pedalYawFactor * vector3.y + rotorBlade.cyclicRollFactor * vector3.z + rotorBlade.collectiveFactor * inputCollective, -1f, 1f) * rotorBlade.maxDeflection, rotorBlade.localRotAxis) * rotorBlade.defaultRot;
				#rotorBlade.wing.transform.localRotation = localRotation;
			#}
			#if (doCollision && damageLevel > 0)
			#{
				#float num7 = damageTorqueDragFactor * (float)damageLevel * inputShaft.outputRPM;
				#dragTorque += num7;
			#}
			#inputShaft.AddResistanceTorque(dragTorque);
			#rb.AddTorque(inputShaft.transmission.inputTorque * torqueMassRatio * rotationTransform.up);
		#}

		#private Vector3 CalculateFlapVelocity(Vector3 position, float tanSpeed)
		#{
			#float num = tanSpeed * flapVelFactor;
			#Vector3 to = Vector3.ProjectOnPlane(position - base.transform.position, base.transform.up);
			#Vector3 from = base.transform.forward;
			#if (rotateFlapCalcToVel)
			#{
				#from = Vector3.ProjectOnPlane(rb.velocity, base.transform.up);
			#}
			#return Mathf.Cos((Vector3.SignedAngle(from, to, -base.transform.up) + 90f + flapCycleOffset) * ((float)Math.PI / 180f)) * num * rotationTransform.up;
		#}
#
		#private Vector3 CalculateInducedFlow()
		#{
			#float radarAltitude = flightInfo.radarAltitude;
			#float num = groundEffectCurve.Evaluate(radarAltitude);
			#Vector3 zero = Vector3.zero;
			#for (int i = 0; i < blades.Length; i++)
			#{
				#zero += blades[i].wing.liftVector + blades[i].wing.dragVector;
			#}
			#float num2 = AerodynamicsController.fetch.AtmosDensityAtPositionMetric(base.transform.position);
			#float num3 = (float)Math.PI * collisionRadius * collisionRadius;
			#Vector3 target = Mathf.Sqrt(zero.magnitude * 1000f / Mathf.Max(0.001f, 2f * num2 * num3)) * inducedFlowRateFactor * num * zero.normalized;
			#inducedFlowP = Vector3.MoveTowards(inducedFlowP, target, inducedFlowChangeRate * Time.fixedDeltaTime);
			#return inducedFlowP;
		#}
#
		#private Vector3 CalculateInducedFlowAtPosition(Vector3 position, Vector3 inducedFlow)
		#{
			#Vector3 vector = rotationTransform.position - rb.velocity * inducedFlowLagRate;
			#float num = Mathf.Max(0f, (position - vector).magnitude - collisionRadius * inducedFlowRadiusFactor);
			#inducedFlow *= 1f - Mathf.Pow(Mathf.Clamp01(inducedFlowFadeRate * num), 0.5f);
			#return inducedFlow;
		#}
