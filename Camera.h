#pragma once

#include <directxtk/SimpleMath.h>

namespace jRenderer {

using DirectX::SimpleMath::Matrix;
using DirectX::SimpleMath::Vector3;

class Camera {
  public:
    Camera() { UpdateViewDir(); }

    Matrix GetViewRow();
    Matrix GetProjRow();
    Vector3 GetEyePos();

    void UpdateViewDir();
    void UpdateKeyboard(const float dt, bool const keyPressed[256]);
    void UpdateMouse(float mouseNdcX, float mouseNdcY);
    void MoveForward(float dt);
    void MoveRight(float dt);
    void MoveUp(float dt);
    void SetAspectRatio(float aspect);

  public:
    bool m_useFirstPersonView = false;

  private:
    /*Vector3 m_position = Vector3(-1.3469f, 0.461257f, -0.408304f);*/
    Vector3 m_position = Vector3(0.0f, 2.0f, 0.0f);
    Vector3 m_viewDir = Vector3(0.0f, 0.0f, 1.0f);
    Vector3 m_upDir = Vector3(0.0f, 1.0f, 0.0f); // �̹� ���������� ����
    Vector3 m_rightDir = Vector3(1.0f, 0.0f, 0.0f);

    // roll, pitch, yaw
    // https://en.wikipedia.org/wiki/Aircraft_principal_axes
    float m_yaw = 0.441786f, m_pitch = -0.449422f;

    float m_speed = 0.5f; // �����̴� �ӵ�

    // �������� �ɼǵ� ī�޶� Ŭ������ �̵�
    float m_projFovAngleY = 90.0f;
    float m_nearZ = 0.005f;
    float m_farZ = 50.0f;
    float m_aspect = 16.0f / 9.0f;
    bool m_usePerspectiveProjection = true;
};

} // namespace jRenderer
