#include "Camera.h"

#include <iostream>

namespace jRenderer {

using namespace DirectX;

// Return View Matrix about Camera. (Row major)
// you can think it is View frustum obj matrix.
Matrix Camera::GetViewRow() {

    // When rendering, it makes 'View' Matrix.
    // In this example, 'upDir' is fixed about Y
    // View Transformation is like that virtual world move on other way.
    return Matrix::CreateTranslation(-this->m_position) *
           Matrix::CreateRotationY(-this->m_yaw) *
           Matrix::CreateRotationX(this->m_pitch);
    // why it calc about translation, rotationY and rotationX?
    // �⺻������ �� ���������� Z������ ���� ���ϰ� �Ǿ� �Ѵ�. �׷��Ƿ�,
    // �����̼� Y�� ���ؼ� m_yaw�� �������� ������ ���̴�. �׷��ٸ� ��?
    // -m_position�� �ϴ� ���ϱ�,
}

Vector3 Camera::GetEyePos() { return m_position; }

void Camera::UpdateViewDir() {
    m_viewDir = Vector3::Transform(Vector3(0.0f, 0.0f, 1.0f),
                                   Matrix::CreateRotationY(this->m_yaw));
    m_rightDir = m_upDir.Cross(m_viewDir);
}

void Camera::UpdateKeyboard(const float dt, bool const keyPressed[256]) {
    if (m_useFirstPersonView) {
        if (keyPressed['W'])
            MoveForward(dt);
        if (keyPressed['S'])
            MoveForward(-dt);
        if (keyPressed['D'])
            MoveRight(dt);
        if (keyPressed['A'])
            MoveRight(-dt);
        if (keyPressed['E'])
            MoveUp(dt);
        if (keyPressed['Q'])
            MoveUp(-dt);
    }
}

void Camera::UpdateMouse(float mouseNdcX, float mouseNdcY) {
    // m_yaw = mouseNdcX * DirectX::XM_2PI;: �� �ڵ�� ���콺�� X ��ǥ�� ����
    // ī�޶��� ���� ȸ���� yaw�� ����մϴ�.
    //  ���콺�� X ��ǥ ���� -1���� 1������ ������ ������, �̸� ��ü 360��(0����
    //  2������� ���� ��)�� ������Ű�� ���� DirectX::XM_2PI�� �����ݴϴ�. �̴�
    //  ���콺�� �¿� �̵��� ���� ī�޶� �¿�� ȸ���ϵ��� �մϴ�.

    // m_pitch = mouseNdcY * DirectX::XM_PIDIV2;: �� �ڵ�� ���콺�� Y ��ǥ��
    // ���� ī�޶��� ���� ȸ���� pitch�� ����մϴ�. ���콺�� Y ��ǥ ���� -1����
    // 1������ ������ ������, �̸� 90��(��/2 ����)�� ������Ű�� ����
    // DirectX::XM_PIDIV2�� �����ݴϴ�. �̴� ���콺�� ���� �̵��� ���� ī�޶�
    // ���Ʒ��� ȸ���ϵ��� �մϴ�.
    if (m_useFirstPersonView) {
        // calc how much roatate a mouse.
        m_yaw = mouseNdcX * DirectX::XM_2PI;      // �¿� 360��
        m_pitch = mouseNdcY * DirectX::XM_PIDIV2; // �� �Ʒ� 90��

        UpdateViewDir();
    }
}

void Camera::MoveForward(float dt) {
    // �̵� ���� ��ġ = ���� ��ġ + �̵����� * �ӵ� * �ð�����
    m_position += m_viewDir * m_speed * dt;
}

void Camera::MoveUp(float dt) { m_position += m_upDir * m_speed * dt; }

void Camera::MoveRight(float dt) { m_position += m_rightDir * m_speed * dt; }

void Camera::SetAspectRatio(float aspect) { m_aspect = aspect; }

Matrix Camera::GetProjRow() {
    return m_usePerspectiveProjection
               ? XMMatrixPerspectiveFovLH(XMConvertToRadians(m_projFovAngleY),
                                          m_aspect, m_nearZ, m_farZ)
               : XMMatrixOrthographicOffCenterLH(-m_aspect, m_aspect, -1.0f,
                                                 1.0f, m_nearZ, m_farZ);
}

} // namespace jRenderer